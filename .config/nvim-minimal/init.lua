-- Set runtime path to point to nvim-minimal directory
vim.api.nvim_command('set runtimepath^=~/.config/nvim-minimal/')

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- DISABLE Nvim tree file explorer
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- python host
vim.g.python3_host_prog = "/opt/homebrew/bin/python3.11"

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set fold method
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--vim.cmd([[ set nofoldenable ]])

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
--vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Netrw (if not disabled)
--vim.g.netrw_browse_split = 0
--vim.g.netrw_banner = 0
--vim.g.netrw_winsize = 25
--vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
--vim.g.netrw_liststyle = 3
--vim.g.netrw_hide = 1
--vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

-- Tabs and spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- undodir
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

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

-- colorscheme
vim.cmd.colorscheme('onedark')

-- Smooth scrollwheel
vim.keymap.set({"n", "v", "i"}, "<ScrollWheelLeft>", "z<Left>")
vim.keymap.set({"n", "v", "i"}, "<ScrollWheelRight>", "z<Right>")
vim.keymap.set({"n", "v", "i"}, "<ScrollWheelUp>", "<C-Y>")
vim.keymap.set({"n", "v", "i"}, "<ScrollWheelDown>", "<C-E>")
