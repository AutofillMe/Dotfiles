local add = function(plugin)
    vim.pack.add(plugin, { confirm = false })
end

add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    "https://github.com/stevearc/aerial.nvim",
}

require("aerial").setup {}
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
    extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
        aerial = {},
    },
}
require("telescope").load_extension "aerial"

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Telescope [F]ind [F]iles" })
vim.keymap.set("n", "<leader>fn", function()
    require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config", follow = true }
end, { desc = "Telescope [F]ind [N]eovim Files" })
vim.keymap.set("n", "<leader>fa", function()
    require("telescope.builtin").find_files { follow = true, no_ignore = true, hidden = true }
end, { desc = "Telescope [F]ind [A]ll Files" })
vim.keymap.set("n", "<leader>fo", function()
    require("telescope").extensions.aerial.aerial()
end, { desc = "Telescope [F]ind Code [O]utline" })
