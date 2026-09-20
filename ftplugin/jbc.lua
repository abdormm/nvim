vim.bo.iskeyword = "@,48-57,_,192-255,."
vim.bo.indentkeys = "0=RETURN,0=END,=ELSE,=THEN,=DO,:"
vim.bo.commentstring = "* %s"

local subroutine = "^%s*SUBROUTINE%s+"
local program = "^%s*PROGRAM%s+"
local label = "^%s*[%w_.]+:%s*$"
local case = "^%s*CASE%s+"
local end_case = "^%s*END%s+CASE%s*$"
local line_comment = "^%s*;?%s*%*.*"
local eol_comment = ";%s*%*.*$"

local starts = {
    subroutine,
    program,
    "^%s*FOR%s+",
    "^%s*WHILE%s+",
    "^%s*UNTIL%s+",
    "^%s*BEGIN%s+",
    "%s+THEN%s*$",
    "^%s*LOOP%s*$",
    "%s+ELSE%s*$",
    "%s+DO%s*$",
}

local ends = {
    "^%s*END%s*$",
    "^%s*REPEAT%s*$",
    "^%s*END%s+",
    "^%s*ELSE%s*$",
    "^%s*WHILE%s+",
    "^%s*UNTIL%s+",
    "%s+DO%s*$",
    "^%s*NEXT%s+",
}

local skips = {
    label,
    line_comment,
}

local no_indentation = {
    program,
    subroutine,
    label,
}

---Returns `true` if `str` matches any pattern in `patterns`.
---@param str string
---@param patterns string[]
---@return boolean
local function matches_any(str, patterns)
    for _, pattern in ipairs(patterns) do
        if str:match(pattern) then
            return true
        end
    end
    return false
end

---A somewhat dumb indenter but it works really good for most syntactically and
---semantically valid programs.
---@return integer width the number of spaces worth of indent.
function JBC_indent()
    local curr_line = vim.api.nvim_get_current_line()
    if matches_any(curr_line, no_indentation) then return 0 end
    if curr_line:match(line_comment) then return -1 end
    local lnum = vim.v.lnum
    if lnum == 1 then return -1 end

    local prev_lnum = lnum - 1
    local prev_line = ""
    while prev_lnum ~= 0 do
        prev_line = vim.fn.getline(prev_lnum)
        if prev_line ~= "" and not matches_any(prev_line, skips) then break end
        prev_lnum = prev_lnum - 1
    end

    prev_line = prev_line:gsub(eol_comment, "")
    curr_line = curr_line:gsub(eol_comment, "")

    local prev_width = vim.fn.indent(prev_lnum)

    if matches_any(curr_line, ends) then
        if matches_any(prev_line, starts) then return prev_width end
        -- to close both CASE block and BEGIN CASE block
        if not prev_line:match(case) and curr_line:match(end_case) then
            return math.max(prev_width - 2 * vim.bo.shiftwidth, 0)
        end
        return math.max(prev_width - vim.bo.shiftwidth, 0)
    end

    if matches_any(prev_line, starts) then
        return prev_width + vim.bo.shiftwidth
    end

    --- will happen with all CASE statements except the one right after
    --- BEGIN CASE
    if curr_line:match(case) then
        if prev_line:match(case) then
            return prev_width
        end
        return math.max(prev_width - vim.bo.shiftwidth, 0)
    end

    if prev_line:match(case) then
        return prev_width + vim.bo.shiftwidth
    end

    return prev_width
end

vim.bo.indentexpr = "v:lua.JBC_indent()"
