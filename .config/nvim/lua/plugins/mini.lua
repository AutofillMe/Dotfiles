---@param repo string
---@return string
local function gh(repo)
    return "https://github.com/" .. repo
end

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
require("mini.starter").setup()
