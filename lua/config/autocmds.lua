-- =========================
-- Formatting Function & Keymap
-- =========================
local function format_src()
    vim.cmd("write")
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")

    if ft == "c" then
        vim.cmd("!astyle --style=gnu --suffix=none " .. file)
    elseif ft == "cpp" or ft == "hpp" then
        vim.cmd("!clang-format -i " .. file)
    elseif ft == "perl" then
        vim.cmd("!astyle --style=gnu --suffix=none " .. file)
    elseif ft == "py" or ft == "python" then
        vim.cmd("!autopep8 --in-place --aggressive --aggressive " .. file)
    elseif ft == "java" then
        vim.cmd("!astyle --style=java --suffix=none " .. file)
        -- use prettier for javascript, typescript, css, html, json, markdown
        -- and make sure tab width is 4
    elseif ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" or
        ft == "css" or ft == "html" or ft == "json" then
        vim.cmd("!prettier --write --tab-width 4 " .. file)
    else
        vim.cmd("normal! gg=G")
        return
    end
    vim.cmd("edit!")
end
vim.keymap.set("n", "~", format_src, { noremap = true, silent = true })


-- 专门为 LeetCode 文件关闭光标行高亮
vim.api.nvim_create_autocmd("FileType", {
    pattern = "leetcode",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- =========================
-- Cursor Highlighting
-- =========================
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function() vim.o.cursorline = true end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function() vim.o.cursorline = false end,
})

-- =========================
-- Filetype Dictionary
-- =========================
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- local dict_path = vim.fn.expand("~/.vim/dict/")
-- local file_dicts = {
-- php = "php_funclist.dict",
-- css = "css.dict",
-- c = "c.dict",
-- cpp = "cpp.dict",
-- scale = "scale.dict",
-- javascript = "javascript.dict",
-- html = { "javascript.dict", "css.dict" },
-- markdown = "markdown.dict",
-- python = "python.dict",
-- }

-- for ft, dicts in pairs(file_dicts) do
-- vim.api.nvim_create_autocmd("FileType", {
-- pattern = ft,
-- callback = function()
-- if type(dicts) == "table" then
-- for _, dict in ipairs(dicts) do
-- vim.opt_local.dictionary:append(dict_path .. dict)
-- end
-- else
-- vim.opt_local.dictionary:append(dict_path .. dicts)
-- end
-- end,
-- })
-- end

-- =========================
-- Code Runner
-- =========================
local mappings = {
    cpp = ':w<CR>:terminal cmd.exe /C "g++ % -o %:r.exe && %:r.exe"<CR>',
    c = ':w<CR>:terminal cmd.exe /C "gcc % -o %:r.exe && %:r.exe"<CR>',
    -- rust = ':w<CR>:terminal cmd.exe /C "rustc % -o %:r.exe && %:r.exe"<CR>',
    python = ':w<CR>:terminal cmd.exe /C "python % & pause"<CR>',
    java = ':w<CR>:terminal cmd.exe /C "javac % && java %:r & pause"<CR>',
    sh = ':w<CR>:terminal cmd.exe /C "bash % & pause"<CR>',
    javascript = ':w<CR>:terminal cmd.exe /C "node % & pause"<CR>',
    lua = ':w<CR>:terminal cmd.exe /C "lua % & pause"<CR>',
    html = ':w<CR>:terminal cmd.exe /C "cd %:p:h && live-server --open=%:t"<CR>',
    tex = ':w<CR>:terminal cmd.exe /C "latexmk -xelatex -pvc -interaction=nonstopmode "%""<CR>',
    R = ':w<CR>:terminal cmd.exe /C "Rscript % & pause"<CR>',
    ps1 =
    ':w<CR>:terminal powershell.exe /C "powershell -ExecutionPolicy Bypass -File %; Read-Host -Prompt \\"Press Enter to continue\\"" <CR>',
    -- rust first cd the current buffer's parent directory
    -- then compile and run
    rust = ':w<CR>:terminal cmd.exe /C "cd %:p:h && rustc % -o %:t:r.exe && %:t:r.exe & pause"<CR>',
    -- use deno for ts
    typescript = ':w<CR>:terminal cmd.exe /C "deno run % & pause"<CR>',
}


for ft, rhs in pairs(mappings) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
            vim.keymap.set("c", "run", rhs, { buffer = true, noremap = true, silent = false })
        end,
    })
end

-- =========================
-- Filetype Adjustments
-- =========================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.md", "*.mdown", "*.mkd", "*.mkdn", "*.markdown", "*.mdwn" },
    callback = function() vim.bo.filetype = "markdown" end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.go" },
    callback = function() vim.bo.filetype = "go" end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.js" },
    callback = function()
        vim.bo.filetype = "javascript"
        local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        if content:find("<[%w]+") then
            vim.bo.filetype = "javascriptreact"
        end
    end,
})

-- Quickfix for C/CPP
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.keymap.set("n", "<leader><Space>", ":w<CR>:make<CR>", { buffer = true, noremap = true, silent = true })
    end,
})

-- Prevent python indent override
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.bo.indentexpr = ""
    end,
})

-- Restore Cursor Position
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line([['"]])
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.cmd('normal! g`"')
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Neovide Force Transparent
-- vim.cmd([[
-- augroup NeovideForceTransparent
-- autocmd!
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "Normal",       { bg = "none" })
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "none" })
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "SignColumn",   { bg = "none" })
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "NvimTreeNormal",{ bg = "none" })
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "TelescopeNormal",{ bg = "none" })
-- autocmd ColorScheme * ++once lua vim.api.nvim_set_hl(0, "Pmenu",         { bg = "none" })
-- augroup END
-- ]])

-- =========================
-- Auto-Title Header
-- =========================
local function set_title()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines > 0 and not (#lines == 1 and lines[1] == "") then return end

    local fname = vim.fn.expand("%:t")
    local fname_r = vim.fn.expand("%:r")
    local ext = vim.fn.expand("%:e")
    local ft = vim.bo.filetype

    if ext == "py" then
        ft = "python"
    elseif ext == "sh" then
        ft = "sh"
    elseif ext == "rb" then
        ft = "ruby"
    elseif ext == "java" then
        ft = "java"
    end

    local header = {}
    if ft == "python" then
        header = { "#!/usr/bin/env python", "# coding=utf-8", "" }
    elseif ft == "sh" then
        header = { "#!/bin/bash", "" }
    elseif ft == "ruby" then
        header = { "#!/usr/bin/env ruby", "# encoding: utf-8", "" }
    elseif ft == "c" or ft == "cpp" then
        header = {
            "/*************************************************************************",
            "        > File Name: " .. fname,
            "      > Author: xiaobin118",
            "      > Mail: 3350844208@qq.com",
            "      > Created Time: " .. os.date("%c"),
            " ************************************************************************/",
            "",
        }
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, header)

    if ext == "cpp" then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { "#include<iostream>", "using namespace std;", "" })
    elseif ext == "c" then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { "#include<stdio.h>", "" })
    elseif ext == "h" then
        vim.api.nvim_buf_set_lines(0, -1, -1, false,
            { "#ifndef _" .. string.upper(fname_r) .. "_H", "#define _" .. string.upper(fname_r) .. "_H", "#endif" })
    elseif ft == "java" then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { "public class " .. fname_r, "" })
    end
    vim.cmd("normal! G")
end

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*",
    callback = set_title,
})


-- help me write kep mapping to resize the current split window using Ctrl + Arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })


-- Populate quickfix with all diagnostics and open it (ALE-like)
vim.keymap.set('n', '<leader>qe', function()
    vim.diagnostic.setqflist({ open = false }) -- puts diagnostics into quickfix
    vim.cmd('copen 10')                        -- open with height 10
end, { noremap = true, silent = true })
