return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      -- 1. Prevent Enter from accepting choices
      ["<CR>"] = { "fallback" },
      -- 2. Map Tab to accept the selection (with snippet/fallback handling)
      ["<Tab>"] = { "accept", "fallback" },
      -- 3. Map Ctrl+Enter to also accept the selection
      ["<C-CR>"] = { "accept", "fallback" },
    },
  },
}
