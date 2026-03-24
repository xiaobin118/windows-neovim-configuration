return {
    {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- this file can contain specific instructions for your project
            instructions_file = "avante.md",
            model = "Gemini3-flash",
            -- providers = {
            -- moonshot = {
            -- endpoint = "https://api.moonshot.ai/v1",
            -- model = "kimi-k2-0711-preview",
            -- timeout = 30000, -- Timeout in milliseconds
            -- extra_request_body = {
            -- temperature = 0.75,
            -- max_tokens = 32768,
            -- },
            -- },
            -- },
            provider = "copilot",
            providers = {
                copilot = {
                    model = "claude-haiku-4.5" -- change this to the Copilot model you want
                },
            },
            input = {
                provider = "snacks",
            },
            auto_suggestions_provider = "copilot", -- optional: use Copilot for inline suggestions
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
        }
    }
}
