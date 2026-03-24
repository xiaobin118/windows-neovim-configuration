return {
    -- Core DAP
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = { "DapContinue", "DapToggleBreakpoint", "DapStepOver" },
        config = function()
            local dap = require("dap")

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = "js-debug-adapter",
                    args = { "${port}" },
                },
            }

            ------------------------------------------------------------------
            -- 2. JS / TS configurations (Node.js)
            ------------------------------------------------------------------
            for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch current file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                        protocol = "inspector",
                        console = "integratedTerminal",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            ------------------------------------------------------------------
            -- 3. Keymaps for core DAP (you can move to keymaps.lua if you want)
            ------------------------------------------------------------------
            vim.keymap.set("n", "<Alt>dc", function() dap.continue() end, { desc = "DAP Continue" })
            vim.keymap.set("n", "<Alt>dt", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
            vim.keymap.set("n", "<Alt>dov", function() dap.step_over() end, { desc = "DAP Step Over" })
            vim.keymap.set("n", "<Alt>di", function() dap.step_into() end, { desc = "DAP Step Into" })
            vim.keymap.set("n", "<Alt>dot", function() dap.step_out() end, { desc = "DAP Step Out" })
        end,
    },

    -- DAP UI
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        keys = { "DapUiOpen", "DapUiClose" },
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Auto open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Optional manual toggle
            vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
        end,
    },

    -- Virtual text
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        keys = { "DapVirtualTextEnable", "DapVirtualTextDisable" },
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
            })
        end,
    },

    -- Telescope integration
    {
        "nvim-telescope/telescope-dap.nvim",
        lazy = true,
        cmd = "Telescope dap",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-telescope/telescope.nvim",
        },
    },
}
