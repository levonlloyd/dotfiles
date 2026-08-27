return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
	},
	config = function()
		local neotest = require("neotest")
		local root_pattern = require("lspconfig.util").root_pattern(
			"pnpm-workspace.yaml",
			"vitest.config.ts",
			"vitest.config.mts",
			"vitest.config.js",
			"package.json"
		)

		neotest.setup({
			adapters = {
				require("neotest-vitest")({
					vitestCommand = "pnpm exec vitest",
					cwd = function(path)
						return root_pattern(path)
					end,
					filter_dir = function(name)
						return name ~= "node_modules" and name ~= ".turbo"
					end,
				}),
			},
		})

		vim.keymap.set("n", "<leader>tn", function()
			neotest.run.run()
		end, { desc = "[T]est [N]earest" })
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "[T]est [F]ile" })
		vim.keymap.set("n", "<leader>tS", function()
			neotest.run.stop()
		end, { desc = "[T]est [S]top" })
		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "[T]est [S]ummary" })
		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true, auto_close = true })
		end, { desc = "[T]est [O]utput" })
	end,
}
