#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly MODULES=("bash" "vim")


echo "Dotfiles directory: ${DOTFILES_DIR}"

# ==========================================
# 检查并安装 GNU Stow
# ==========================================
if ! command -v stow &>/dev/null; then
    echo "GNU Stow is not installed. Installing..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v yum &>/dev/null; then
        sudo yum install -y stow
    else
        echo "Error: Unsupported package manager. Please install GNU Stow manually."
        exit 1
    fi
fi

# ==========================================
# 从当前仓库同步基础配置文件
# ==========================================
cd "$DOTFILES_DIR"

echo ""
echo "Stowing modules: ${MODULES[*]}"
for module in "${MODULES[@]}"; do
    if [ -d "$module" ]; then
        # -R: restow（幂等），注意非 stow 管理的同名文件会被覆盖
        stow -v -R -t "$HOME" "$module"
        echo "-> Stowed $module"
    else
        echo "Warning: Module '$module' not found in $DOTFILES_DIR. Skipping."
    fi
done

# ==========================================
# 提供交互式的第三方工具环境安装入口
# ==========================================
echo ""
echo "======================================"
echo "    Base configurations applied!"
echo "======================================"
echo ""
echo "Do you want to install additional environment tools?"
echo "If this is a new machine, you can type 'y' to install them."
echo ""

_run_install() {
    local name="$1"
    local script="$DOTFILES_DIR/scripts/$2"
    read -p "Install ${name}? [y/N]: " answer || true
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        if [ ! -f "$script" ]; then
            echo "Error: Install script not found: $script"
            return 1
        fi
        bash "$script"
    fi
}

_run_install "FNM (Fast Node Manager)"                 "install_fnm.sh"
_run_install "SDKMAN (SDK Manager)"                    "install_sdkman.sh"

echo ""
echo "All done! Please run 'source ~/.bashrc' or restart your terminal."
