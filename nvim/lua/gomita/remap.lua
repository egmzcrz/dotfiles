-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Buffer remaps
vim.keymap.set({ 'n' }, '<Space>x', ':bd<CR>', { silent = true, desc = 'Buffer Delete' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Ergonomic search for word
vim.keymap.set("n", "ñ", "/\\c")

-- File formatting keymaps
vim.keymap.set("n", "<leader>fi", function() vim.lsp.buf.format() end, { desc = '[F]ormat [I]ndentation' })

-- Transform file
-- NOTE: Applies only to CSV files
vim.keymap.set("n", "<leader>T,", ":%!column -ts','<CR>", { desc = '[T]ransform [,] separated file' })
vim.keymap.set("n", "<leader>T ", ":%s/ \\+/,/g<CR>", { desc = '[T]ransform [ ] separated file' })
vim.keymap.set("n", "<leader>T;", ":%s/;/,/g<CR>", { desc = '[T]ransform [;] separated file' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
