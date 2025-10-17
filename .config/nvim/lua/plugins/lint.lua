return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = {
          "--config",
          vim.fn.stdpath("config") .. "/lua/plugins/cfg_linters/global.markdownlint-cli2.yaml",
          "--",
        },
      },
    },
  },
}
