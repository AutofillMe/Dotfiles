---@param repo string
---@return string
local function gh(repo) return "https://github.com/" .. repo end

-- Tabout w/ neotab
vim.pack.add { gh "kawre/neotab.nvim" }
---@diagnostic disable-next-line: missing-parameter
require("neotab").setup()

-- Pretty little command line popup
vim.pack.add { gh "rachartier/tiny-cmdline.nvim" }
require("vim._core.ui2").enable {}

vim.o.cmdheight = 0

---@diagnostic disable-next-line: missing-fields
require("tiny-cmdline").setup {
    on_reposition = require("tiny-cmdline").adapters.blink,
    ---@diagnostic disable-next-line: missing-fields
    width = {
        value = "70%", -- "N%" = fraction of editor columns, integer = absolute columns
    },
}

-- Treesj
vim.pack.add { gh "wansmer/treesj" }
require("treesj").setup {
    use_default_keymaps = false,
}
vim.keymap.set("n", "<leader>m", require("treesj").toggle)

-- Indent markers
vim.pack.add { gh "lukas-reineke/indent-blankline.nvim" }
require("ibl").setup()

-- Todo comments yay!
vim.pack.add { gh "folke/todo-comments.nvim" }
require("todo-comments").setup { signs = false }
