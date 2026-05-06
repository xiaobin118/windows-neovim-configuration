return {
    -- Persistent breakpoints
    {
        "Weissle/persistent-breakpoints.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
            })
        end,
    },

    -- Core DAP
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local data = vim.fn.stdpath("data")
            local mason_pkg = data .. "\\mason\\packages\\"
            local mason_bin = data .. "\\mason\\bin\\"

            ------------------------------------------------------------------
            -- JS Debug Adapter (Deno)
            ------------------------------------------------------------------
            local js_debug_server =
                mason_pkg .. "js-debug-adapter\\js-debug\\src\\dapDebugServer.js"

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = "node",
                    args = { js_debug_server, "${port}" },
                },
            }

            local deno_common = {
                type = "pwa-node",
                request = "launch",
                cwd = "${fileDirname}",
                runtimeExecutable = "deno",
                protocol = "inspector",
                console = "integratedTerminal",
                port = 9229,
                address = "127.0.0.1",
                attachSimplePort = 9229,
                justMyCode = true,
                smartStep = true,
                skipFiles = {
                    "<node_internals>/**",
                    "node:/**",
                    "deno:*",
                    "ext:*",
                },
                sourceMaps = false,
            }

            local deno_basic = vim.tbl_deep_extend("force", deno_common, {
                name = "Deno: run file",
                runtimeArgs = {
                    "run",
                    "--inspect-brk=127.0.0.1:9229",
                    "${file}",
                },
            })

            dap.configurations.typescript = { deno_basic }
            dap.configurations.javascript = { deno_basic }

            ------------------------------------------------------------------
            -- ✅ C / C++ (codelldb)
            ------------------------------------------------------------------
            local codelldb_path = mason_bin .. "codelldb.cmd"

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch (codelldb)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "\\",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.c = dap.configurations.cpp

            ------------------------------------------------------------------
            -- Keymaps
            ------------------------------------------------------------------
            vim.keymap.set("n", "<F5>", function() dap.continue() end)
            vim.keymap.set("n", "<F9>", "<cmd>PBToggleBreakpoint<cr>")
            vim.keymap.set("n", "<F10>", function() dap.step_over() end)
            vim.keymap.set("n", "<F11>", function() dap.step_into() end)
            vim.keymap.set("n", "<F12>", function() dap.step_out() end)

            vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
            vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)

            vim.keymap.set("n", "<leader>du", function()
                local ok, dapui = pcall(require, "dapui")
                if ok then dapui.toggle() end
            end)
        end,
    },

    -- UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    -- Virtual text
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("nvim-dap-virtual-text").setup(
                {
                    enabled = true,
                    enabled_commands = true,
                    highlight_changed_variables = true,
                    highlight_new_as_changed = true,
                }
            )
        end,
    },
}
