return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config

        opts = {
            instructions_file = "avante.md",

            --------------------------------------------------
            -- ✅ 默认 DeepSeek
            --------------------------------------------------
            provider = "deepseek",

            providers = {
                --------------------------------------------------
                -- Copilot（保留）
                --------------------------------------------------
                copilot = {
                    model = "claude-haiku-4.5",
                },

                --------------------------------------------------
                deepseek = {
                    __inherited_from = "openai",
                    api_key_name = "DEEPSEEK_API_KEY",
                    endpoint = "https://api.deepseek.com",
                    model = "deepseek-chat",

                    extra_request_body = {
                        temperature = 0.7,
                        max_tokens = 32768,
                    },
                },

                --------------------------------------------------
                ["deepseek-v4-pro"] = {
                    __inherited_from = "openai",
                    api_key_name = "DEEPSEEK_API_KEY",
                    endpoint = "https://api.deepseek.com",
                    model = "deepseek-v4-pro",

                    extra_request_body = {
                        temperature = 0.7,
                        max_tokens = 32768,
                        -- 禁用 thinking mode，否则 avante 的 tool call 多轮交互会报错：
                        -- "The reasoning_content in the thinking mode must be passed back to the API"
                        thinking = { type = "disabled" },
                    },
                },
            },

            input = {
                provider = "snacks",
            },

            auto_suggestions_provider = "copilot",

            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
        },
    },
}
