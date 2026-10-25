require("crilp.opts")
require("crilp.remaps")
require("crilp.autocmd")

local snippets_path = vim.fn.stdpath("config") .. "/lua/custom/snippets"

require("luasnip.loaders.from_vscode").load({
  paths = { snippets_path },
})
