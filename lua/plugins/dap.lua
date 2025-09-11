-- lua/plugins/dap.lua
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui", -- UI for dap
            "theHamsta/nvim-dap-virtual-text", -- inline variable text
            "nvim-neotest/nvim-nio", -- required by dap-ui
        },
        config = function()
            local dap = require("dap")
            -- ✅ Go Debugger (Delve)
            dap.adapters.go = {
                type = "executable",
                command = "dlv",
                args = { "dap" },
            }

            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug file",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "go",
                    name = "Debug package",
                    request = "launch",
                    program = "${fileDirname}",
                },
                {
                    type = "go",
                    name = "Attach",
                    request = "attach",
                    processId = require("dap.utils").pick_process,
                },
            }

            -- ✅ C / C++ Debugger (LLDB)
            dap.adapters.lldb = {
                type = "executable",
                command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- adjust path if needed
                name = "lldb",
            }

            dap.configurations.c = {
                {
                    name = "Launch C program",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.cpp = dap.configurations.c -- same setup for C++
            local dapui = require("dapui")

            -- Setup dap-ui
            dapui.setup()

            -- Auto-open/close dap-ui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Setup virtual text
            require("nvim-dap-virtual-text").setup()

            -- Keymaps
            local map = vim.keymap.set
            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F12>", dap.restart)

            vim.keymap.set("n", "<leader>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            map("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
            map("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
                { desc = "DAP Conditional Breakpoint" })

            map("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP Open REPL" })
            map("n", "<leader>dl", function() dap.run_last() end, { desc = "DAP Run Last" })
            map("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
        end,
    },
}

