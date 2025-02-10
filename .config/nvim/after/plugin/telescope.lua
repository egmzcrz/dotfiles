-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
        path_display = { "truncate" },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope error diagnostics' })

vim.keymap.set('n', '<leader>fB', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fb', builtin.current_buffer_fuzzy_find,
    { desc = 'Telescope fuzzy search in current buffer' })

vim.keymap.set('n', '<leader>fT', builtin.live_grep, { desc = 'Telescope text search' })
vim.keymap.set('n', '<leader>ft',
    function()
        require('telescope.builtin').grep_string({ only_sort_text = true, search = '' })
    end, { desc = 'Telescope fuzzy text search' })
