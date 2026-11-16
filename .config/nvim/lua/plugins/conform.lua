local add = function(plugin)
    vim.pack.add(plugin, { confirm = false })
end

add { "https://github.com/stevearc/conform.nvim" }
require("conform").setup {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        json = { "jq" },
    },
}
vim.keymap.set({ "n", "v" }, "<leader>fm", function()
    require("conform").format { async = true, lsp_format = "fallback" }
end, { desc = "Conform Format buffer" })
