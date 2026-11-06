vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
}

-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
    extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
    },
}

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>fn", function()
    require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config", follow = true }
end, { desc = "Telescope find Neovim files" })
vim.keymap.set(
    "n",
    "<leader>fa",
    require("telescope.builtin").find_files { follow = true, no_ignore = true, hidden = true },
    { desc = "Telescope find all files" }
)
