local map = vim.keymap.set

-- Disable select mode
map({ "n", "v" }, "gh", "<nop>")
map({ "n", "v" }, "gH", "<nop>")

-- Macro stuff
map("n", "Q", "@@")

-- Blackhole
map("n", "x", '"_x', { desc = "General Cut letter to void" })
map({ "n", "o" }, "<leader>d", [["_d]], { desc = "General delete letter to void" })

-- Ctrl + s to save work
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save" })

-- Auto-Tabbed move selected line(s)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "General Smart move line(s) down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "General Smart move line(s) up" })
map("n", "n", "nzzzv", { desc = "General Search stay centered next" })
map("n", "N", "Nzzzv", { desc = "General Search stay centered previous" })

-- Paste without replace
map("x", "<leader>p", [["_dP]], { desc = "General Paste without replace" })

-- Yank to system vs nvim buffer stuff
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "General Yank to system buffer" })
map("n", "<leader>Y", [["+Y]], { desc = "General Yank line to system buffer" })

-- Cool tools from @ThePrimeagen
map("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "CMD Find and Replace" })
map("n", "<leader>z", "<cmd>!chmod +x %<CR>", { silent = true, desc = "CMD chmod +x <file>" })

-- goto definition split from @ProgrammingHeadache
map("n", "gs", function()
    vim.cmd "vsplit"
    vim.cmd "wincmd l"
    vim.lsp.buf.definition()
end, { desc = "LSP Goto Def and Split" })
