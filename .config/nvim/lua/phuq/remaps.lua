vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear all highlights" })

-- General Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- Terminal stuff
vim.keymap.set("n", "<leader>h", function()
    vim.cmd "split"
    vim.cmd "terminal"
    vim.cmd("resize " .. math.floor(vim.o.lines / 3))
    vim.cmd "startinsert"
end, { desc = "Term Open terminal in horizontal split" })

vim.keymap.set("n", "<leader>v", function()
    vim.cmd "vsplit"
    vim.cmd "terminal"
    vim.cmd "startinsert"
end, { desc = "Term Open terminal to the right" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Term Exit terminal mode" })

-- File Navigation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Smart move line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Smart move line(s) up" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search stay centered next" })
vim.keymap.set("n", "N", "Nzzzv", { desc "Search stay centered previous" })
vim.keymap.set("n", "Y", "y$", { desc ="Yank to end of line" })

-- Paste without replace
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without replace" })

-- Disable select mode
vim.keymap.set({ "n", "v" }, "gh", "<nop>")
vim.keymap.set({ "n", "v" }, "gH", "<nop>")

-- Macro stuff
vim.keymap.set("n", "Q", "@@")

-- Blackhole
vim.keymap.set("n", "x", '"_x', { desc = "Cut letter to void" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete letter to void" })

-- Cool tools from @ThePrimeagen
vim.keymap.set(
    "n",
    "<leader>rr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "CMD Find and Replace" }
)
vim.keymap.set("n", "<leader>rx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "CMD chmod +x <file>" })

-- Comment out stuff
vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- goto definition split from @ProgrammingHeadache
vim.keymap.set("n", "gs", function()
    vim.cmd "vsplit"
    vim.cmd "wincmd l"
    vim.lsp.buf.definition()
end, { desc = "LSP Goto Def and Split" })
