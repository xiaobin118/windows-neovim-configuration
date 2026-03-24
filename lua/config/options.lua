-- =========================
-- General Options (Terminal & GUI)
-- =========================
vim.g.mapleader = ","
vim.g.mkdp_preview_options = { katex = {} }

-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- UI & Layout
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cursorline = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.history = 1000
vim.o.cmdheight = 1
vim.o.ruler = true
vim.o.showcmd = true
vim.o.laststatus = 2
vim.o.termguicolors = true
vim.o.wrap = true
-- if in md file, then wrap
if vim.bo.filetype == "markdown" then
    vim.o.wrap = true
end

vim.o.hidden = true
vim.o.scrolloff = 3
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.opt.fillchars = { vert = "│", stl = " ", stlnc = " " }
vim.opt.colorcolumn = ""
vim.opt.swapfile = false
vim.opt.backup = false

-- Highlighting: find a comfortable color scheme for LineNr and CursorLineNr-- skyblue and bluewhite:
vim.cmd [[highlight LineNr guifg=#87CEEB ]]
vim.cmd [[ highlight FloatBorder guifg=cyan guibg=NONE ]] -- Customize border color

-- vim.opt.winblend = 30 -- Floating window transparency level
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Language & Encoding
vim.o.langmenu = "zh_CN.UTF-8"
vim.o.helplang = "cn"
if vim.fn.has("nvim-0.6") == 1 then
    vim.o.encoding = "utf-8"
end

-- enhance undo
-- Persistent undo: keep undo history across restarts
vim.opt.undofile = true

-- Store undo files in a dedicated directory
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir

-- System
vim.o.autoread = true
vim.o.autowrite = true
vim.o.clipboard = "unnamedplus"
-- vim.o.shada = ""

-- =========================
-- 🚀 Neovide Configuration
-- =========================
if vim.g.neovide then
    -- 1. Font Settings
    -- Use a Nerd Font. Fallback included.
    vim.o.guifont = "JetBrainsMono Nerd Font:h14"
    vim.g.neovide_text_gamma = 0.8
    vim.g.neovide_text_contrast = 0.1

    -- 2. Window Appearance (Blur & Transparency)
    vim.g.neovide_opacity = 0.88
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    -- 3. Cursor Animation (The "Cool" Stuff)
    -- Options: "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe"
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_opacity = 50.0 -- Intensity of the effect
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
    vim.g.neovide_cursor_vfx_particle_density = 3.0
    vim.g.neovide_cursor_vfx_particle_speed = 10.0

    -- Smooth scrolling and cursor movement
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_cursor_animation_length = 0.10 -- Lower = snappier, Higher = smoother
    vim.g.neovide_cursor_trail_size = 0.4
    -- vim.cmd([[highlight Cursor guibg=#ffcc00 guifg=#000000]])

    -- 4. Behavior & Performance
    vim.g.neovide_refresh_rate = 120 -- Set to your monitor's refresh rate
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_no_idle = true
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_input_ime = true -- Enable IME support for Chinese input

    -- =========================
    -- ⌨️ Neovide Specific Keymaps
    -- =========================

    -- Toggle Fullscreen (F11)
    vim.g.neovide_fullscreen = false
    vim.keymap.set("n", "<F11>", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { silent = true, desc = "Toggle Fullscreen" })

    -- Zoom In/Out (Ctrl + / Ctrl -)
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set({ "n", "v" }, "<C-=>", function() change_scale_factor(1.1) end)
    vim.keymap.set({ "n", "v" }, "<C-->", function() change_scale_factor(1 / 1.1) end)
    vim.keymap.set({ "n", "v" }, "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end)

    -- Corrected Transparency Logic
    -- We use vim.g.neovide_opacity directly instead of a complex hex calculation
    local change_transparency = function(delta)
        local new_opacity = (vim.g.neovide_opacity or 0.8) + delta
        -- Clamp between 0.1 and 1.0
        if new_opacity < 0.1 then new_opacity = 0.1 end
        if new_opacity > 1.0 then new_opacity = 1.0 end
        vim.g.neovide_opacity = new_opacity
    end
    vim.keymap.set({ "n", "v", "o" }, "<A-]>", function() change_transparency(0.04) end)

    vim.keymap.set({ "n", "v", "o" }, "<A-[>", function() change_transparency(-0.04) end)


    vim.g.neovide_floating_blur_amount_x = 2.0 -- Horizontal blur
    vim.g.neovide_floating_blur_amount_y = 2.0 -- Vertical blur

    -- Copy/Paste fix for GUI
    vim.keymap.set("v", "<C-c>", '"+y')    -- Copy
    vim.keymap.set("n", "<C-v>", '"+P')    -- Paste normal mode
    vim.keymap.set("v", "<C-v>", '"+P')    -- Paste visual mode
    vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<C-v>", '<C-r>+') -- Paste insert mode
end
