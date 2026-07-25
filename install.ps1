# ============================================================
# Neovim Configuration Installer — Windows (PowerShell)
# Repo: https://github.com/xiaobin118/windows-neovim-configuration
# ============================================================

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/xiaobin118/windows-neovim-configuration.git"
$NvimConfigDir = "$env:LOCALAPPDATA\nvim"
$NvimDataDir = "$env:LOCALAPPDATA\nvim-data"
$BackupDir = "$env:LOCALAPPDATA\nvim-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Neovim Config Installer (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- Prerequisite checks ---
$errors = @()
$warnings = @()

# Required: Neovim (0.9+)
if (-not (Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    $errors += "Neovim not found. Install it via: winget install Neovim.Neovim"
}
else {
    $nvimVersion = (nvim --version 2>$null | Select-Object -First 1) -replace '.*v?(\d+\.\d+).*', '$1'
    if ([Version]$nvimVersion -lt [Version]"0.9") {
        $errors += "Neovim $nvimVersion is too old. Version 0.9+ required. Update via: winget upgrade Neovim.Neovim"
    }
}

# Required: Git
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    $errors += "Git not found. Install it via: winget install Git.Git"
}

# Optional: Node.js
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    $warnings += "Node.js not found (optional — needed for some LSP servers). Install via: winget install OpenJS.NodeJS.LTS"
}

# Optional: Python 3
if (-not (Get-Command "python3" -ErrorAction SilentlyContinue) -and -not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    $warnings += "Python 3 not found (optional — needed for some LSP servers). Install via: winget install Python.Python.3"
}

if ($errors.Count -gt 0) {
    Write-Host "[ERROR] Missing prerequisites:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host ""
    Write-Host "Please install the missing tools and re-run this script." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[OK] Neovim: $(nvim --version | Select-Object -First 1)" -ForegroundColor Green
Write-Host "[OK] Git: $(git --version)" -ForegroundColor Green

if (Get-Command "node" -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Node.js: $(node --version)" -ForegroundColor Green
}
if (Get-Command "python3" -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Python: $(python3 --version)" -ForegroundColor Green
}
elseif (Get-Command "python" -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Python: $(python --version)" -ForegroundColor Green
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "[WARNING] Optional dependencies missing:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
Write-Host ""

# --- Back up existing config ---
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

# --- Clone configuration ---
Write-Host "[INFO] Cloning configuration from GitHub..." -ForegroundColor Cyan
git clone --depth 1 $RepoUrl $NvimConfigDir
Write-Host "[OK] Configuration installed to: $NvimConfigDir" -ForegroundColor Green
Write-Host ""

# --- Done ---
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
