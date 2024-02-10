-- Transform file
vim.keymap.set("n", "<leader>T,", ":%!column -ts','<CR>", { desc = '[T]ransform [,] separated file' })
vim.keymap.set("n", "<leader>T ", ":%s/ \\+/,/g<CR>", { desc = '[T]ransform [ ] separated file' })
vim.keymap.set("n", "<leader>T;", ":%s/;/,/g<CR>", { desc = '[T]ransform [;] separated file' })
