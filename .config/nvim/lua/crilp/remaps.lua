local map = vim.keymap.set

-- Ctrl + s to save work
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save" })

-- Auto-Tabbed move selected line(s)
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Paste without replace
map("x", "<leader>p", [["_dP]], { desc = "Paste without replace" })

-- Yank to system vs nvim buffer stuff
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system buffer" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system buffer" })

-- Cool tools
map("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and Replace" })
map("n", "<leader>z", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x <file>" })
