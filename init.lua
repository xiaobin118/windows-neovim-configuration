-- Load
-- Auto cd to current buffer's directory when switching buffers
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*", -- Apply to all buffers
    callback = function()
        -- Only run if the buffer is associated with a file (skip empty/unnamed buffers)
        local buf_path = vim.fn.expand("%:p:h") -- Get directory of current buffer file
        if buf_path ~= "" and vim.fn.isdirectory(buf_path) == 1 then
            vim.cmd("cd " .. buf_path) -- Change working directory
            -- Optional: Print confirmation (remove if you don't want it)
            -- print("Working directory changed to: " .. buf_path)
        end
    end,
    desc = "Auto change working directory to current buffer's directory",
})

require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy.nvim and tell it to load specs from lua/plugins/
require("lazy").setup({
    spec = {
        { import = "plugins" }, -- Import all files in lua/plugins directory
    },
    change_detection = {
        notify = false,
    },
})

-- Load colorscheme after plugins (safe fallback)
vim.cmd.colorscheme("catppuccin")
