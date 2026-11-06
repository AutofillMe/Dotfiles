-- Tabout w/ neotab
vim.pack.add { "https://github.com/kawre/neotab.nvim" }
---@diagnostic disable-next-line: missing-parameter
require("neotab").setup()

-- Pretty little command line popup
vim.pack.add { "https://github.com/rachartier/tiny-cmdline.nvim" }
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
vim.pack.add { "https://github.com/wansmer/treesj" }
require("treesj").setup {
    use_default_keymaps = false,
}
vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "Toggle treesj" })

-- Indent markers
vim.pack.add { "https://github.com/lukas-reineke/indent-blankline.nvim" }
require("ibl").setup()

-- Todo comments
vim.pack.add { "https://github.com/folke/todo-comments.nvim" }
require("todo-comments").setup { signs = false }

-- Live Server
vim.pack.add { "https://github.com/barrettruth/live-server.nvim" }
vim.keymap.set(
    "n",
    "<leader>lss",
    "<cmd>LiveServerStart %<CR>",
    { silent = true, desc = "Live-server Start Live Server" }
)
vim.keymap.set(
    "n",
    "<leader>lst",
    "<cmd>LiveServerStop %<CR>",
    { silent = true, desc = "Live-server Stop Live Server" }
)
