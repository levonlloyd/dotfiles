return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"mxsdev/nvim-dap-vscode-js",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("nvim-dap-virtual-text").setup()
		require("mason-nvim-dap").setup({
			ensure_installed = { "js" },
			automatic_installation = true,
		})

		local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
		if vim.fn.isdirectory(js_debug_path) == 1 then
			require("dap-vscode-js").setup({
				debugger_path = js_debug_path,
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			})
		else
			vim.notify(
				"js-debug-adapter is not installed yet. Open :Mason and install it, then restart Neovim.",
				vim.log.levels.WARN
			)
		end

		for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch current file",
					cwd = "${workspaceFolder}",
					program = "${file}",
					sourceMaps = true,
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					cwd = "${workspaceFolder}",
					processId = require("dap.utils").pick_process,
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome on localhost:3000",
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
				},
			}
		end

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional breakpoint" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
	end,
}
