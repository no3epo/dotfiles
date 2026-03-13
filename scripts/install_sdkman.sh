#!/usr/bin/env bash
set -e

echo "======================================"
echo "        Installing SDKMAN!"
echo "======================================"

# 1. 安装 SDKMAN（禁止自动修改 .bashrc）
echo "[1/4] Downloading SDKMAN!..."
export SDKMAN_DIR="$HOME/.sdkman"
curl -s "https://get.sdkman.io?rcupdate=false" | bash

# 2. bashrc 自动加载 .bashrc.d/
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

# 3. 写入 SDKMAN 初始化插件
echo "[3/4] Writing SDKMAN init plugin..."
cat << 'EOF' > "$PLUGIN_DIR/sdkman.sh"
# SDKMAN initialization
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
chmod +x "$PLUGIN_DIR/sdkman.sh"

echo "[4/4] Done!"
echo "Run: source ~/.bashrc"
