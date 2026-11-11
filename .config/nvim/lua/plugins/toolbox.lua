local add = function(plugin)
    vim.pack.add(plugin, { confirm = false })
end

-- Tabout w/ neotab
add { "https://github.com/kawre/neotab.nvim" }
---@diagnostic disable-next-line: missing-parameter
require("neotab").setup()

-- Pretty little command line popup
add { "https://github.com/rachartier/tiny-cmdline.nvim" }
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
add { "https://github.com/wansmer/treesj" }
require("treesj").setup {
    use_default_keymaps = false,
}
vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "Toggle treesj" })

-- Indent markers
add { "https://github.com/lukas-reineke/indent-blankline.nvim" }
require("ibl").setup()

-- Todo comments
add { "https://github.com/folke/todo-comments.nvim" }
require("todo-comments").setup { signs = false }

-- Live Server
add { "https://github.com/barrettruth/live-server.nvim" }
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
