-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Page up/down movement
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { silent = true })

-- Buffer remaps
vim.keymap.set({ 'n' }, '<Space>x', ':bd<CR>', { silent = true, desc = 'Buffer Delete' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Ergonomic search for word
vim.keymap.set("n", "ñ", "/\\c")

-- Turn off highlight until the next search
vim.keymap.set("n", "<Space>h", ":noh<CR>")

-- File formatting keymaps
vim.keymap.set("n", "<leader>fi", function() vim.lsp.buf.format() end, { desc = '[F]ormat [I]ndentation' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Align to char
vim.keymap.set({"n", "v"}, "<leader>a", ":Tabularize /", { desc = '[A]lign to char' })

-- Smooth scrollwheel
vim.keymap.set({"n", "v"}, "<ScrollWheelLeft>", "z<Left>")
vim.keymap.set({"n", "v"}, "<ScrollWheelRight>", "z<Right>")
vim.keymap.set({"n", "v"}, "<ScrollWheelUp>", "<C-Y>")
vim.keymap.set({"n", "v"}, "<ScrollWheelDown>", "<C-E>")
vim.keymap.set({"i"}, "<ScrollWheelUp>", "<C-O><C-Y>")
vim.keymap.set({"i"}, "<ScrollWheelDown>", "<C-O><C-E>")
vim.keymap.set({"i"}, "<ScrollWheelLeft>", "<C-O>z<Left>")
vim.keymap.set({"i"}, "<ScrollWheelRight>", "<C-O>z<Right>")

