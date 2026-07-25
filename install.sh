#!/usr/bin/env bash
# ============================================================
# Neovim Configuration Installer — Linux / macOS
# Repo: https://github.com/xiaobin118/xiaobin118-s-neovim-configuration
# ============================================================

set -euo pipefail

REPO_URL="https://github.com/xiaobin118/xiaobin118-s-neovim-configuration.git"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d-%H%M%S)"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Neovim Config Installer (Linux/macOS)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# --- Prerequisite checks ---
errors=()

if ! command -v nvim &>/dev/null; then
    errors+=("Neovim not found. Install it via your package manager (brew/apt/dnf/pacman).")
fi
if ! command -v git &>/dev/null; then
    errors+=("Git not found. Install it via your package manager.")
fi

if [ ${#errors[@]} -gt 0 ]; then
    echo -e "${RED}[ERROR] Missing prerequisites:${NC}"
    for err in "${errors[@]}"; do
        echo -e "${RED}  - $err${NC}"
    done
    echo ""
    echo -e "${YELLOW}Please install the missing tools and re-run this script.${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Neovim: $(nvim --version | head -1)${NC}"
echo -e "${GREEN}[OK] Git: $(git --version)${NC}"
echo ""

# --- Back up existing config ---
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}[INFO] Existing config found at: $NVIM_CONFIG_DIR${NC}"
    echo -e "${YELLOW}[INFO] Backing up to: $BACKUP_DIR${NC}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    echo -e "${GREEN}[OK] Backup complete.${NC}"
fi
if [ -d "$NVIM_DATA_DIR" ]; then
    echo -e "${YELLOW}[INFO] Removing old nvim data (will be recreated on first launch)...${NC}"
    rm -rf "$NVIM_DATA_DIR"
fi
if [ -d "$NVIM_STATE_DIR" ]; then
    rm -rf "$NVIM_STATE_DIR"
fi
echo ""

# --- Clone configuration ---
echo -e "${CYAN}[INFO] Cloning configuration from GitHub...${NC}"
git clone --depth 1 "$REPO_URL" "$NVIM_CONFIG_DIR"
echo -e "${GREEN}[OK] Configuration installed to: $NVIM_CONFIG_DIR${NC}"
echo ""

# --- Done ---
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' — Lazy.nvim will auto-install all plugins"
echo "  2. Open :Mason to install language servers you need"
echo ""
echo -e "Optional: Neovide GUI — https://github.com/neovide/neovide/releases"
echo ""
