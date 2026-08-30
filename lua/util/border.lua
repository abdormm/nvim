-- NOTE technically bitwise or should be used but since lua 5.1 doesn't have
-- bitwise operators and using functions from "bit" module would be verbose I
-- opted to using addition instead. So avoid repetition (in bitwise or
-- repetition doesn't matter).
-- EDIT luajit supports bitwise or

local M = {}

-- directions
local up = 1
local down = 2
local left = 4
local right = 8

-- corners
local NW = 1
local NE = 3
local SE = 5
local SW = 7

M.styles = {
    rounded = {
        [up] = "╵",
        [down] = "╷",
        [right] = "╶",
        [left] = "╴",
        [up | down] = "│",
        [up | left] = "╯",
        [up | right] = "╰",
        [down | left] = "╮",
        [down | right] = "╭",
        [left | right] = "─",
        [up | down | left] = "┤",
        [up | down | right] = "├",
        [up | left | right] = "┴",
        [down | left | right] = "┬",
        [up | down | left | right] = "┼",
    },
    single = {
        [up] = "╵",
        [down] = "╷",
        [right] = "╶",
        [left] = "╴",
        [up | down] = "│",
        [up | left] = "┘",
        [up | right] = "└",
        [down | left] = "┐",
        [down | right] = "┌",
        [left | right] = "─",
        [up | down | left] = "┤",
        [up | down | right] = "├",
        [up | left | right] = "┴",
        [down | left | right] = "┬",
        [up | down | left | right] = "┼",
    },
}

---A utility to create borders for window that may be connected to another
---window.
---**Example:**
---```lua
---    local border = require("util.border")
---    local d = border.directions
---    print(vim.inspect(border.win_border("single", d.up | d.down)))
---    print(vim.inspect(border.win_border("single", d.up | d.down | d.right | d.left)))
---```
---**Output:**
---```lua
---    { "├", "─", "┤", "│", "┤", "─", "├", "│" }
---    { "┼", "─", "┼", "│", "┼", "─", "┼", "│" }
---```
---@param style "single" | "rounded"
---@param connections integer?
---@return string[]
M.win_border = function(style, connections)
    local s = M.styles[style]
    local win_up, win_down, win_left, win_right = 0, 0, 0, 0
    if connections then
        win_up = connections & up
        win_down = connections & down
        win_left = connections & left
        win_right = connections & right
    end
    return {
        s[down | right | win_up | win_left],
        s[left | right],
        s[down | left | win_up | win_right],
        s[up | down],
        s[up | left | win_down | win_right],
        s[left | right],
        s[up | right | win_down | win_left],
        s[up | down],
    }
end

M.directions = {}
M.directions.up = up
M.directions.down = down
M.directions.left = left
M.directions.right = right

M.corners = {}
M.corners.NW = NW
M.corners.NE = NE
M.corners.SW = SW
M.corners.SE = SE

return M
