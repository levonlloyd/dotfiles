return {
	-- Conform: formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },

		opts = {
			-- Format on save
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback", -- use LSP only when no formatter is configured
			},

			-- Filetype -> formatter(s)
			formatters_by_ft = {
				lua = { "stylua" },

				-- Your old prettier target list
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },

				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },

				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				hcl = { "terraform_fmt" },

				-- Ruff: emulate your "extend-select I" + format
				python = { "ruff_fix_imports", "ruff_format" }, -- runs sequentially  [oai_citation:1‡GitHub](https://github.com/stevearc/conform.nvim)

				-- oxfmt for JS/TS (+ JSX/TSX)
				javascript = { "oxfmt" },
				typescript = { "oxfmt" },
				javascriptreact = { "oxfmt" },
				typescriptreact = { "oxfmt" },
			},

			-- Per-formatter tweaks / custom formatters
			formatters = {
				-- shfmt indent = 4 (your old args = { "-i", "4" })
				shfmt = {
					append_args = { "-i", "4" },
				},

				-- Create a "variant" of ruff_fix that always adds your import-select
				ruff_fix_imports = {
					inherit = "ruff_fix",
					append_args = { "--extend-select", "I" },
				},

				-- Custom formatter: project-local oxfmt via yarn, writes in-place
				-- oxfmt's --write is the default, included for clarity  [oai_citation:2‡Oxc](https://oxc.rs/docs/guide/usage/formatter/cli.html?utm_source=chatgpt.com)
				oxfmt = {
					command = "pnpm",
					args = { "exec", "oxfmt", "--write", "$FILENAME" },
					stdin = false,
				},
			},
		},

		config = function(_, opts)
			require("conform").setup(opts)
			-- Optional: manual format key
			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({ async = false })
			end, { desc = "Format" })
		end,
	},

	-- Mason auto-install for conform formatters (replacement for mason-null-ls)
	-- Note: oxfmt is project-local, so not installed via Mason.
	{
		"zapling/mason-conform.nvim",
		dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
		config = function()
			require("mason-conform").setup({
				ensure_installed = {
					"stylua",
					"shfmt",
					"terraform_fmt",
					"ruff",
					"prettier",
				},
				automatic_installation = true,
			})
		end,
	},
}
