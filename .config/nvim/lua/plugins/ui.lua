local add = function(plugin)
    vim.pack.add(plugin, { confirm = false })
end

-- File Tree Picker
add { "https://github.com/nvim-tree/nvim-tree.lua" }
require("nvim-tree").setup {
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
    },
    view = {
        width = 30,
        preserve_window_proportions = true,
    },
    renderer = {
        root_folder_label = false,
        highlight_git = "all",
        indent_markers = { enable = true },
        icons = {
            glyphs = {
                default = "󰈚",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                },
                git = { unmerged = "" },
            },
        },
    },
}
vim.keymap.set("n", "<leader>a", vim.cmd.NvimTreeToggle, { desc = "nvimtree toggle window" })

-- Tab/Buff Bar
add { "https://github.com/romgrk/barbar.nvim" }
require("barbar").setup {
    sidebar_filetypes = {
        NvimTree = true,
    },
    icons = {
        filetype = {
            enabled = true,
        },
        pinned = { button = "", filename = true },
    },
}
vim.keymap.set("n", "<Tab>", vim.cmd.BufferNext, { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", vim.cmd.BufferPrevious, { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bp", vim.cmd.BufferPick, { desc = "[B]uffer [P]ick" })
vim.keymap.set("n", "<leader>bn", vim.cmd.BufferPin, { desc = "[B]uffer Pi[N]/Unpi[N]" })
vim.keymap.set("n", "<leader>br", vim.cmd.BufferRestore, { desc = "[B]uffer [R]estore" })
vim.keymap.set("n", "<leader>x", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd "bdelete!"
    elseif vim.bo.buftype == "nofile" then
        vim.cmd "close"
    else
        vim.cmd "BufferClose"
    end
end, { desc = "Close Window" })

-- which-key
add { "https://github.com/folke/which-key.nvim" }
require("which-key").setup {
    delay = 0,
    icons = {
        mappings = vim.g.have_nerd_font,
    },
}
vim.keymap.set("n", "<leader>wk", vim.cmd.WhichKey, { desc = "[w]hich-[k]ey all keymaps" })

-- Theme
add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }
require("catppuccin").setup {
    flavour = "mocha",
    no_italic = true,
}
vim.cmd.colorscheme "catppuccin-nvim"

-- Status Line
add { "https://github.com/nvim-lualine/lualine.nvim" }
require("lualine").setup {
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
}
