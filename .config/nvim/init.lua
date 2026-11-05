-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

require "phuq.opts"
require "phuq.remaps"
require "phuq.autocmd"

vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float {
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
            }
        end,
    },
}

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

---@param repo string
---@return string
local function gh(repo) return "https://github.com/" .. repo end

vim.pack.add { gh "nvim-tree/nvim-tree.lua" }
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

vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle, { desc = "nvimtree toggle window" })

vim.pack.add { gh "folke/which-key.nvim" }
require("which-key").setup {
    delay = 0,
    icons = {
        mappings = vim.g.have_nerd_font,
    },
}
vim.keymap.set("n", "<leader>wk", vim.cmd.WhichKey, { desc = "which-key all keymaps" })

vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }
require("catppuccin").setup {
    flavour = "mocha",
    no_italic = true,
}
vim.cmd.colorscheme "catppuccin-nvim"

vim.pack.add { gh "nvim-mini/mini.nvim" }
if vim.g.have_nerd_font then
    require("mini.icons").setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
end
require("mini.ai").setup {
    mappings = {
        around_next = "aa",
        inside_next = "ii",
    },
    n_lines = 500,
}
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.cmdline").setup()

vim.pack.add { gh "nvim-lualine/lualine.nvim" }
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

-- LSP and Conform
require "plugins.lsp"
require "plugins.conform"

-- Treesitter & friends
require "plugins.treesitter"

-- Code Completion
require "plugins.cmp"

-- Toolbox
require "plugins.toolbox"
