#!/usr/bin/env bash
set -e

echo "======================================"
echo "    Installing FNM (Fast Node Manager)"
echo "======================================"

# 1. 下载和安装 FNM（禁止自动修改 shell 配置文件）
echo "[1/4] Downloading fnm..."
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# 2. bashrc 自动加载 ~/.bashrc.d/
echo "[2/4] Configuring ~/.bashrc to load ~/.bashrc.d/..."
PLUGIN_DIR="$HOME/.bashrc.d"
mkdir -p "$PLUGIN_DIR"

if ! grep -q "bashrc.d" "$HOME/.bashrc"; then
    cat << 'EOF' >> "$HOME/.bashrc"

# Auto-load ~/.bashrc.d/
BASHRC_D="$HOME/.bashrc.d"
if [ -d "$BASHRC_D" ]; then
    for config_file in "$BASHRC_D"/*.sh; do
        if [ -r "$config_file" ]; then
            source "$config_file"
        fi
    done
    unset config_file BASHRC_D
fi
EOF
else
    echo "      -> Loader already strictly exists in ~/.bashrc. Skipping injection."
fi

# 3. 写入 FNM 初始化插件
echo "[3/4] Writing FNM init plugin..."
cat << 'EOF' > "$PLUGIN_DIR/fnm.sh"
# FNM initialization
export FNM_PATH="${FNM_PATH:-$HOME/.local/share/fnm}"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd --shell bash)"
fi
EOF
chmod +x "$PLUGIN_DIR/fnm.sh"

echo "[4/4] Done!"
echo "Run: source ~/.bashrc"
