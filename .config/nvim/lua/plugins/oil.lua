vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
