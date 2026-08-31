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
        Write-Host "[OK] ${cmdName}: $((Get-Command $cmdName).Source)" -ForegroundColor Green
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

    $script:errors += "Failed to auto-install ${cmdName}. Install it manually (scoop install $scoopName or winget install $wingetId)."
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
    Write-Host "[ERROR] Missing/failed items:" -ForegroundColor Red
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
