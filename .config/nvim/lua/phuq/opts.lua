vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Line numbers
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"

-- Mouse
vim.opt.mouse = ""

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.breakindent = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- File Handling
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(vim.opt.undodir:get(), "p")
vim.opt.swapfile = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Appearance
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    extends = "›",
    precedes = "‹",
}
vim.opt.fillchars = { eob = " " }
vim.opt.wrap = false

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"

-- Miscellaneous
vim.opt.confirm = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
