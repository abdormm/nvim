---Notes:
---`vim.filetype.match` checks in the following order:
---    1. full path (if buf has a name) 
---    2. only the filename (see :t expand())
---    3. patterns with non-negative priority
---    4. extension
---    5. patterns with negative priority
---    6. contents
vim.filetype.add {
    extension = {
        pom = "xml",
        b = "jbc",
    },
}
