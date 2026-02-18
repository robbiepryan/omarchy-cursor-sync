#!/bin/bash
# Omarchy Cursor Sync - Installation Script

set -e

echo "🎨 Installing Omarchy Cursor Sync..."

# Check dependencies
check_dep() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ Missing dependency: $1"
        exit 1
    fi
}

check_dep python3
check_dep npm
check_dep git

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIBATA_DIR="$HOME/src/Bibata_Cursor"
VENV_DIR="$HOME/.local/bibata-venv"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/bibata-omarchy-sync"
HOOKS_DIR="$HOME/.config/omarchy/hooks"
CACHE_DIR="$HOME/.local/share/bibata-omarchy-cache"

# Clone Bibata if not exists
if [[ ! -d "$BIBATA_DIR" ]]; then
    echo "📦 Cloning Bibata Cursor..."
    mkdir -p "$HOME/src"
    git clone https://github.com/ful1e5/Bibata_Cursor.git "$BIBATA_DIR"
fi

# Install npm dependencies
echo "📦 Installing npm dependencies..."
cd "$BIBATA_DIR" && npm install

# Create Python venv
if [[ ! -d "$VENV_DIR" ]]; then
    echo "🐍 Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

echo "📦 Installing Python dependencies..."
"$VENV_DIR/bin/pip" install -q clickgen toml

# Create directories
mkdir -p "$BIN_DIR" "$CONFIG_DIR" "$HOOKS_DIR" "$CACHE_DIR"

# Install scripts
echo "📝 Installing scripts..."
cp "$SCRIPT_DIR/omarchy-sync-cursor" "$BIN_DIR/"
cp "$SCRIPT_DIR/cursor-sync" "$BIN_DIR/"
chmod +x "$BIN_DIR/omarchy-sync-cursor" "$BIN_DIR/cursor-sync"

# Install config if not exists
if [[ ! -f "$CONFIG_DIR/config.toml" ]]; then
    cp "$SCRIPT_DIR/config.example.toml" "$CONFIG_DIR/config.toml"
fi

# Install hook
cp "$SCRIPT_DIR/hooks/theme-set.example" "$HOOKS_DIR/theme-set"
chmod +x "$HOOKS_DIR/theme-set"

# Add to Hyprland config if not present
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
if [[ -f "$HYPR_CONF" ]] && ! grep -q "cursor-auto.conf" "$HYPR_CONF"; then
    echo "📝 Adding cursor config to Hyprland..."
    echo "source = ~/.config/hypr/cursor-auto.conf" >> "$HYPR_CONF"
fi

# Create initial cursor config
touch "$HOME/.config/hypr/cursor-auto.conf"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  cursor-sync <theme-name>     # Sync cursor to theme"
echo "  cursor-sync <theme> --dry-run # Preview colors"
echo ""
echo "Cursors will auto-sync when you run: omarchy-theme-set <theme>"
