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

-- mini.nvim (run first, since icon support is in mini.nvim)
require "plugins.mini"

-- UI
require "plugins.ui"

-- LSP and Conform
require "plugins.lsp"
require "plugins.conform"

-- Treesitter & friends
require "plugins.treesitter"

-- Code Completion
require "plugins.cmp"

-- Toolbox
require "plugins.toolbox"

-- Telescope
require "plugins.telescope"

