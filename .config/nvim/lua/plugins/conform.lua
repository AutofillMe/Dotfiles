---@param repo string
---@return string
local function gh(repo) return "https://github.com/" .. repo end

vim.pack.add { gh "stevearc/conform.nvim" }
require("conform").setup {
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        json = { "jq" },
    },
}
vim.keymap.set(
    { "n", "v" },
    "<leader>fm",
    function() require("conform").format { async = true } end,
    { desc = "Conform Format buffer" }
)
