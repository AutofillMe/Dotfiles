local add = function(plugin)
    vim.pack.add('https://github.com/' .. plugin, { confirm = false })
end

-- Tabout w/ neotab
add "kawre/neotab.nvim"
---@diagnostic disable-next-line: missing-parameter
require("neotab").setup()

-- Pretty little command line popup
add "rachartier/tiny-cmdline.nvim"
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
add "wansmer/treesj"
require("treesj").setup {
    use_default_keymaps = false,
}
vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "Toggle treesj" })

-- Indent markers
add "lukas-reineke/indent-blankline.nvim"
require("ibl").setup()

-- Todo comments
add "folke/todo-comments.nvim"
require("todo-comments").setup { signs = false }

-- Live Server
add "barrettruth/live-server.nvim"
vim.keymap.set(
    "n",
    "<leader>lss",
    "<cmd>LiveServerStart %<CR>",
    { silent = true, desc = "[L]ive [S]erver Start" }
)
vim.keymap.set(
    "n",
    "<leader>lst",
    "<cmd>LiveServerStop %<CR>",
    { silent = true, desc = "[L]ive [S]erver Stop" }
)

-- Generate Annotations
add "danymat/neogen"
require("neogen").setup {}
vim.keymap.set("n", "<Leader>nf", function()
    require("neogen").generate()
end, { desc = "Generate docstring" })
