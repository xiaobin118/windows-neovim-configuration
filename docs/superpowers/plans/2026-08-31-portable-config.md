# 跨机器可移植化实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 让 nvim 配置在任何 Windows 机器上 clone 仓库 + 运行 `install.ps1` 即可使用，消除硬编码路径与依赖丢失问题。

**Architecture:** 新增 `lua/config/util.lua` 探测模块（`find_executable`），把五处硬编码路径改为探测式（找不到优雅跳过）；`install.ps1` 自动安装必需依赖（mingw 提供 gcc/make、ripgrep），可选依赖仅提示。

**Tech Stack:** Lua (Neovim), PowerShell, scoop/winget

**Spec:** `docs/superpowers/specs/2026-08-31-portable-config-design.md`

---

### Task 1: 新增 `lua/config/util.lua` 探测模块

**Files:**
- Create: `lua/config/util.lua`

- [ ] **Step 1: 创建 util.lua**

```lua
local M = {}

--- 在 PATH 或候选目录中查找可执行文件
---@param name string 可执行文件名（如 "gcc"、"SumatraPDF.exe"）
---@param candidates string[]? 候选目录列表（绝对路径，正斜杠）
---@return string|nil 找到则返回路径，否则 nil
function M.find_executable(name, candidates)
  if vim.fn.executable(name) == 1 then
    return name
  end
  if candidates then
    local ext = vim.fn.has("win32") == 1 and ".exe" or ""
    for _, dir in ipairs(candidates) do
      local full = dir .. "/" .. name .. ext
      if (vim.uv or vim.loop).fs_stat(full) then
        return full
      end
    end
  end
  return nil
end

return M
```

- [ ] **Step 2: 在 headless nvim 中验证探测函数**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua print(require('config.util').find_executable('gcc'))" -c "qa!"`
Expected: 输出 `gcc`（本机 gcc 在 PATH，通过 mingw-lite）

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua print(vim.inspect(require('config.util').find_executable('SumatraPDF.exe', {os.getenv('LOCALAPPDATA') .. '/SumatraPDF'})))" -c "qa!"`
Expected: 输出找到的路径或 `nil`（不报错）

- [ ] **Step 3: Commit**

```bash
git add lua/config/util.lua
git commit -m "feat: add find_executable utility for portable path detection"
```

---

### Task 2: `init.lua` — curl 路径改为探测

**Files:**
- Modify: `init.lua:3-7`

- [ ] **Step 1: 替换硬编码 curl 路径**

原代码（第 3-7 行）：
```lua
if vim.fn.has("win32") == 1 then
    vim.g.plenary_curl_bin_path = "C:\\Windows\\System32\\curl.exe"
    vim.g.copilot_curl = "C:\\Windows\\System32\\curl.exe"
    vim.env.CURL = "C:\\Windows\\System32\\curl.exe"
end
```

替换为：
```lua
if vim.fn.has("win32") == 1 then
    local curl = require("config.util").find_executable("curl", { "C:/Windows/System32" })
    if curl then
        vim.g.plenary_curl_bin_path = curl
        vim.g.copilot_curl = curl
        vim.env.CURL = curl
    end
end
```

- [ ] **Step 2: 验证语法与加载**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua local f,e=loadfile('D:/neovim/nvim-config/nvim/init.lua'); if f then print('syntax ok') else print('ERR: '..tostring(e)) end" -c "qa!"`
Expected: 输出 `syntax ok`（loadfile 只解析不执行，不会触发 lazy 引导）

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat: detect curl path instead of hardcoding System32"
```

---

### Task 3: `treesitter.lua` — 写死 msys2 改为 gcc 探测

**Files:**
- Modify: `lua/plugins/treesitter.lua:8-20`

- [ ] **Step 1: 替换 msys2 硬编码块**

原代码（第 8-20 行，config 函数开头）：
```lua
            local msys_root = [[E:\scoop\apps\msys2\current]]
            local msys_usr_bin = msys_root .. [[\usr\bin]]
            local msys_mingw_bin = msys_root .. [[\mingw64\bin]]
            local msys_gcc = msys_mingw_bin .. [[\gcc.exe]]

            if vim.uv.fs_stat(msys_gcc) then
                vim.env.PATH = msys_mingw_bin .. ";" .. msys_usr_bin .. ";" .. vim.env.PATH
                vim.env.MAKE = msys_usr_bin .. [[\make.exe]]

                require("nvim-treesitter.install").compilers = {
                    msys_gcc,
                }
            end
```

替换为：
```lua
            local util = require("config.util")
            local candidates = {}
            for _, root in ipairs({ os.getenv("SCOOP"), os.getenv("USERPROFILE") .. "/scoop" }) do
                if root then
                    table.insert(candidates, root .. "/apps/msys2/current/mingw64/bin")
                end
            end
            local gcc = util.find_executable("gcc", candidates)

            if gcc then
                require("nvim-treesitter.install").compilers = { gcc }
            end
```

- [ ] **Step 2: 验证**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua local f,e=loadfile('D:/neovim/nvim-config/nvim/lua/plugins/treesitter.lua'); if f then print('syntax ok') else print('ERR: '..tostring(e)) end" -c "qa!"`
Expected: 输出 `syntax ok`

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/treesitter.lua
git commit -m "feat: probe gcc instead of hardcoding msys2 path"
```

---

### Task 4: `lang.lua` — SumatraPDF 探测 + db_ui 反斜杠

**Files:**
- Modify: `lua/plugins/lang.lua:34-43`（vimtex init）
- Modify: `lua/plugins/lang.lua:126`（db_ui）

- [ ] **Step 1: 替换 vimtex 查看器硬编码**

原代码（第 34-43 行）：
```lua
        init = function()
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = [[D:\SumatraPDF\SumatraPDF.exe]]
            vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                build_dir = "",
                options = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "-file-line-error" },
            }
        end,
```

替换为：
```lua
        init = function()
            local util = require("config.util")
            local candidates = {}
            for _, dir in ipairs({ os.getenv("LOCALAPPDATA"), os.getenv("ProgramFiles") }) do
                if dir then
                    table.insert(candidates, dir .. "/SumatraPDF")
                end
            end
            local viewer = util.find_executable("SumatraPDF.exe", candidates)

            vim.g.vimtex_view_method = "general"
            if viewer then
                vim.g.vimtex_view_general_viewer = viewer
                vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
            end
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                build_dir = "",
                options = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "-file-line-error" },
            }
        end,
```

- [ ] **Step 2: db_ui 反斜杠改正斜杠**

原代码（第 126 行）：
```lua
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "\\db_ui"
```
改为：
```lua
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
```

- [ ] **Step 3: 验证**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua local f,e=loadfile('D:/neovim/nvim-config/nvim/lua/plugins/lang.lua'); if f then print('syntax ok') else print('ERR: '..tostring(e)) end" -c "qa!"`
Expected: 输出 `syntax ok`

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lang.lua
git commit -m "feat: probe SumatraPDF path and use forward slashes for db_ui"
```

---

### Task 5: `dap.lua` — 反斜杠、二进制名、存在性检查

**Files:**
- Modify: `lua/plugins/dap.lua:20-130`（config 函数）

- [ ] **Step 1: 重写 config 函数中的路径与 adapter 定义**

原代码第 20-130 行整段替换。关键改动：
- 新增 `mason_exe(name)` helper：检查 `mason/bin/<name>.cmd`（win32）与 `mason/packages/<name>/<name>.exe` 两个候选，返回存在的路径或 nil
- `pwa-node` adapter 的 js-debug-server 路径用正斜杠
- `codelldb` adapter + cpp/c configurations 用 `mason_exe("codelldb")` 包裹，nil 则跳过
- `sharpdbg` adapter + cs configurations 用 `mason_exe("sharpdbg")` 包裹，nil 则跳过

替换后完整 config 函数：
```lua
        config = function()
            local dap = require("dap")
            local data = vim.fn.stdpath("data")
            local mason_pkg = data .. "/mason/packages/"
            local mason_bin = data .. "/mason/bin/"

            -- 返回 mason 安装的可执行文件路径，找不到返回 nil
            local function mason_exe(name)
                local candidates = {
                    mason_bin .. name .. ".cmd",
                    mason_pkg .. name .. "/" .. name .. ".exe",
                }
                for _, p in ipairs(candidates) do
                    if vim.fn.filereadable(p) == 1 then
                        return p
                    end
                end
                return nil
            end

            ------------------------------------------------------------------
            -- JS Debug Adapter (Deno)
            ------------------------------------------------------------------
            local js_debug_server =
            mason_pkg .. "js-debug-adapter/js-debug/src/dapDebugServer.js"

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
            -- C / C++ (codelldb)
            ------------------------------------------------------------------
            local codelldb_path = mason_exe("codelldb")
            if codelldb_path then
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
            end

            -- C# (sharpdbg)
            local sharpdbg_path = mason_exe("sharpdbg")
            if sharpdbg_path then
                dap.adapters.sharpdbg = {
                    type = "executable",
                    command = sharpdbg_path,
                    args = { "--interpreter=vscode" },
                }

                dap.configurations.cs = {
                    {
                        name = "Launch (SharpDbg)",
                        type = "sharpdbg",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to DLL/EXE: ",
                                vim.fn.getcwd() .. "\\bin\\Debug\\",
                                "file"
                            )
                        end,
                        cwd = "${workspaceFolder}",
                        stopAtEntry = false,
                    },
                }
            end

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
```

- [ ] **Step 2: 验证**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua local f,e=loadfile('D:/neovim/nvim-config/nvim/lua/plugins/dap.lua'); if f then print('syntax ok') else print('ERR: '..tostring(e)) end" -c "qa!"`
Expected: 输出 `syntax ok`

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/dap.lua
git commit -m "feat: portable mason paths and existence checks in dap config"
```

---

### Task 6: `lsp.lua` — mason 自动安装 DAP 依赖包

**Files:**
- Modify: `lua/plugins/lsp.lua:15`

- [ ] **Step 1: 扩展 mason ensure_installed**

原代码（第 15 行）：
```lua
        opts = { ensure_installed = { "tree-sitter-cli" } },
```
改为：
```lua
        opts = { ensure_installed = { "tree-sitter-cli", "codelldb", "js-debug-adapter", "sharpdbg" } },
```

- [ ] **Step 2: 验证**

Run: `nvim --headless -u NONE --cmd "set rtp+=D:/neovim/nvim-config/nvim" -c "lua local f,e=loadfile('D:/neovim/nvim-config/nvim/lua/plugins/lsp.lua'); if f then print('syntax ok') else print('ERR: '..tostring(e)) end" -c "qa!"`
Expected: 输出 `syntax ok`

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "feat: auto-install DAP debugger packages via mason"
```

---

### Task 7: `install.ps1` — 自动安装必需依赖

**Files:**
- Modify: `install.ps1`（整文件重写）

- [ ] **Step 1: 重写 install.ps1**

完整新版（整文件替换）：
```powershell
# ============================================================
# Neovim Configuration Installer — Windows (PowerShell)
# Repo: https://github.com/xiaobin118/windows-neovim-configuration
# ============================================================

param(
    [switch]$DepsOnly  # 只安装/检查依赖，跳过备份与 clone
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/xiaobin118/windows-neovim-configuration.git"
$NvimConfigDir = "$env:LOCALAPPDATA\nvim"
$NvimDataDir = "$env:LOCALAPPDATA\nvim-data"
$BackupDir = "$env:LOCALAPPDATA\nvim-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$script:errors = @()
$script:warnings = @()

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Ensure-Scoop {
    if (Test-Command "scoop") { return $true }
    Write-Host "[INFO] Scoop not found. Installing Scoop (user-level, no admin needed)..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    if (-not (Test-Command "scoop")) {
        $script:errors += "Scoop installation failed. Install manually: https://scoop.sh"
        return $false
    }
    Write-Host "[OK] Scoop installed." -ForegroundColor Green
    return $true
}

function Install-Required($cmdName, $scoopName, $wingetId) {
    if (Test-Command $cmdName) {
        Write-Host "[OK] $cmdName: $((Get-Command $cmdName).Source)" -ForegroundColor Green
        return
    }
    Write-Host "[INFO] $cmdName missing. Installing..." -ForegroundColor Yellow

    # 优先 scoop：shim 自动进 PATH（gcc 场景必需）
    if (Ensure-Scoop) {
        scoop install $scoopName 2>&1 | Out-Null
        scoop shim rehash 2>&1 | Out-Null
        if (Test-Command $cmdName) {
            Write-Host "[OK] $cmdName installed via scoop." -ForegroundColor Green
            return
        }
    }

    # 回退 winget
    if (Test-Command "winget") {
        winget install --id $wingetId --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
        if (Test-Command $cmdName) {
            Write-Host "[OK] $cmdName installed via winget." -ForegroundColor Green
            return
        }
    }

    $script:errors += "Failed to auto-install $cmdName. Install it manually (scoop install $scoopName or winget install $wingetId)."
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Neovim Config Installer (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- 前置检查：nvim + git ---
if (-not (Test-Command "nvim")) {
    $script:errors += "Neovim not found. Install it via: winget install Neovim.Neovim"
}
else {
    $nvimVersion = (nvim --version 2>$null | Select-Object -First 1) -replace '.*v?(\d+\.\d+).*', '$1'
    if ([Version]$nvimVersion -lt [Version]"0.9") {
        $script:errors += "Neovim $nvimVersion is too old. Version 0.9+ required. Update via: winget upgrade Neovim.Neovim"
    }
}
if (-not (Test-Command "git")) {
    $script:errors += "Git not found. Install it via: winget install Git.Git"
}

# --- 必需依赖：自动安装 ---
Write-Host "`n--- Required dependencies (auto-install) ---" -ForegroundColor Cyan
Install-Required "rg"    "ripgrep" "BurntSushi.ripgrep.MSVC"
Install-Required "gcc"   "mingw"   "MSYS2.MSYS2"

# --- 重新验证必需依赖 ---
Write-Host "`n--- Dependency verification ---" -ForegroundColor Cyan
if (Test-Command "rg") { Write-Host "[OK] rg: $((Get-Command rg).Source)" -ForegroundColor Green }
else { $script:errors += "ripgrep still missing after install attempt." }

if (Test-Command "gcc") { Write-Host "[OK] gcc: $((Get-Command gcc).Source)" -ForegroundColor Green }
else { $script:warnings += "gcc not found. Treesitter C parser compilation may fail." }

# --- 可选依赖：仅提示 ---
Write-Host "`n--- Optional tools (not auto-installed) ---" -ForegroundColor Cyan
$optional = @(
    @{ name = "lazygit";  cmd = "scoop install lazygit   | winget install JesseDuffield.lazygit" },
    @{ name = "node";     cmd = "scoop install nodejs-lts | winget install OpenJS.NodeJS.LTS" },
    @{ name = "python";   cmd = "scoop install python     | winget install Python.Python.3.12" },
    @{ name = "SumatraPDF"; cmd = "scoop install sumatrapdf | winget install SumatraPDF.SumatraPDF" },
    @{ name = "stylua";   cmd = "scoop install stylua" },
    @{ name = "prettier"; cmd = "npm i -g prettier" },
    @{ name = "clang-format"; cmd = "scoop install llvm" },
    @{ name = "autopep8"; cmd = "pip install autopep8" },
    @{ name = "beautysh"; cmd = "pip install beautysh" }
)
foreach ($opt in $optional) {
    $has = Test-Command ($opt.name.Split('-')[0])
    $status = if ($has) { "[OK]" } else { "[--]" }
    $color = if ($has) { "Green" } else { "DarkGray" }
    Write-Host "$status $($opt.name): $($opt.cmd)" -ForegroundColor $color
}
Write-Host ""

# --- 汇总错误 ---
if ($script:errors.Count -gt 0) {
    Write-Host "[ERROR] Missing/失败 items:" -ForegroundColor Red
    $script:errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host ""
    Write-Host "Fix the above and re-run this script." -ForegroundColor Yellow
    pause
    exit 1
}

# --- 仅依赖模式：到此为止 ---
if ($DepsOnly) {
    Write-Host "[DONE] Dependencies checked/installed. Existing config untouched." -ForegroundColor Green
    pause
    exit 0
}

# --- 备份现有配置 ---
if (Test-Path $NvimConfigDir) {
    Write-Host "[INFO] Existing config found at: $NvimConfigDir" -ForegroundColor Yellow
    Write-Host "[INFO] Backing up to: $BackupDir" -ForegroundColor Yellow
    Move-Item $NvimConfigDir $BackupDir
    Write-Host "[OK] Backup complete." -ForegroundColor Green
}
if (Test-Path $NvimDataDir) {
    Write-Host "[INFO] Removing old nvim-data (will be recreated on first launch)..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $NvimDataDir
}
Write-Host ""

# --- 克隆配置 ---
Write-Host "[INFO] Cloning configuration from GitHub..." -ForegroundColor Cyan
git clone --depth 1 $RepoUrl $NvimConfigDir
Write-Host "[OK] Configuration installed to: $NvimConfigDir" -ForegroundColor Green
Write-Host ""

# --- 完成 ---
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Run 'nvim' — Lazy.nvim will auto-install all plugins" -ForegroundColor White
Write-Host "  2. Open :Mason to install language servers you need" -ForegroundColor White
Write-Host ""
Write-Host "Optional: Neovide GUI — https://github.com/neovide/neovide/releases" -ForegroundColor DarkGray
Write-Host ""
pause
```

- [ ] **Step 2: 本机用 -DepsOnly 验证（不动现有配置）**

Run: `powershell -ExecutionPolicy Bypass -File install.ps1 -DepsOnly`
Expected: 输出 rg/gcc 均已存在（本机已装），可选依赖清单显示，`[DONE] Dependencies checked/installed. Existing config untouched.`

- [ ] **Step 3: Commit**

```bash
git add install.ps1
git commit -m "feat: auto-install required deps (mingw, ripgrep) in installer"
```

---

### Task 8: 综合验证与回归

**Files:**
- 无新增/修改（只验证）

- [ ] **Step 1: 完整启动 nvim（真实配置），确认无错误输出**

Run: `nvim --headless +"lua vim.defer_fn(function() vim.cmd('qa!') end, 5000)" 2>&1`
说明：加载真实配置并让 lazy 跑 5 秒后退出。Expected: stderr 无 Error / 无 hardcoded path 相关报错。

- [ ] **Step 2: 验证各探测在真实配置下返回正确**

Run: `nvim --headless +"lua print(require('config.util').find_executable('rg'))" +"qa!"`
Expected: 输出 `rg`

Run: `nvim --headless +"lua print(require('config.util').find_executable('SumatraPDF.exe', {os.getenv('LOCALAPPDATA')..'/SumatraPDF', os.getenv('ProgramFiles')..'/SumatraPDF'}))" +"qa!"`
Expected: 输出路径或 nil，无报错

- [ ] **Step 3: git 状态复核**

Run: `git status`
Expected: 只含本次计划修改的文件 + 你原有未提交改动（不碰 `.claude/`、`init.bak` 等）

---

## Self-Review 记录

- **Spec 覆盖**：util 模块→Task1；init curl→Task2；treesitter→Task3；SumatraPDF+db_ui→Task4；dap→Task5；mason DAP 包→Task6；install.ps1→Task7；验证→Task8。全覆盖。
- **占位符**：无 TBD/TODO，每步含完整代码与命令。
- **类型一致**：`find_executable(name, candidates)` 签名在 Task1 定义，Task2/3/4 调用一致；`mason_exe(name)` 仅在 Task5 内使用。
