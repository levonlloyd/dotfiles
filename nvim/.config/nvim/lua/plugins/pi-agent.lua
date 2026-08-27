return {
  "pi-nvim-agent",
  dir = vim.fn.expand("~/code/pi-nvim-agent"),
  main = "pi-agent",
  lazy = false,
  opts = {
    models = {
      plan = "anthropic/claude-opus-4-8",
      code = "anthropic/claude-opus-4-8",
      -- gemini via the cursor provider: the google API key lives only in the
      -- interactive shell, not in nvim's environment
      review = "cursor/gemini-3.1-pro",
    },
    git = { branch_prefix = "levon" },
  },
}
