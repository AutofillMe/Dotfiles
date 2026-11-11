local add = function(plugin)
    vim.pack.add(plugin, { confirm = false })
end

add { { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range "2.*" } }
add { "https://github.com/rafamadriz/friendly-snippets" }
require("luasnip").setup {}
require("luasnip.loaders.from_vscode").lazy_load {
    paths = {
        vim.fn.stdpath "data" .. "/site/pack/core/opt/friendly-snippets",
        vim.fn.stdpath "config" .. "/snippets",
    },
}

add { { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.*" } }
require("blink.cmp").setup {
    keymap = {
        preset = "default",
    },

    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
    },

    completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
        default = { "lsp", "path", "snippets" },
    },

    snippets = { preset = "luasnip" },
    fuzzy = { implementation = "prefer_rust" },
    signature = { enabled = true },
}

add({ 'https://github.com/saghen/blink.lib' })
