local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("x", "<leader>p", [["_dP]], { desc = "Paste without replace" })

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system buffer" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system buffer" })

map("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and Replace" })
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x <file>" })
