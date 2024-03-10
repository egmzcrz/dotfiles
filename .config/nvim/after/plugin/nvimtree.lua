-- [[ Configure Nvim Tree]]
require("nvim-tree").setup({
    sort = {
        sorter = "name",
        folders_first = true,
    },
    view = {
        width = 50,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    hijack_cursor = true,
})

-- Open File Explorer (Nvim Tree)
vim.keymap.set("n", "<leader>o", ":NvimTreeToggle<CR>",
    { desc = '[O]pen file explorer', silent = true })
