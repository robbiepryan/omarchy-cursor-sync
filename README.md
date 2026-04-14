# Omarchy Cursor Sync

Automatically build and apply Bibata cursor themes that match your Omarchy theme colors.

![Demo](https://img.shields.io/badge/Hyprland-Compatible-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

When you switch Omarchy themes, this tool:

1. **Reads** colors from the theme's `alacritty.toml`
2. **Computes** aesthetically pleasing cursor colors (base, outline, watch background)
3. **Builds** a custom Bibata cursor theme using `cbmp` + `ctgen`
4. **Installs** it to `~/.local/share/icons/`
5. **Applies** it to Hyprland, XCursor, and GTK apps

Cached themes switch instantly (~0.1s). First-time builds take ~15-20 seconds.

## Features

- 🎨 **Intelligent color selection** - Picks vibrant, contrasting colors from your theme
- ⚡ **Smart caching** - Only rebuilds when theme colors actually change
- 🔄 **Auto-sync** - Integrates with Omarchy's theme hook system
- 🖥️ **Full stack support** - Works with Hyprland, XWayland, and GTK apps
- ⚙️ **Configurable** - Customize colors, sizes, and behavior

## Requirements

- **OS**: Arch-based with Hyprland (Omarchy)
- **Python**: 3.10+
- **Node.js**: 18+ (for `npx`)
- **Dependencies**:
  - [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor) repo
  - Python packages: `clickgen`, `toml`

## Installation

### 1. Clone this repository

```bash
git clone https://github.com/yourusername/omarchy-cursor-sync.git
cd omarchy-cursor-sync
```

### 2. Clone Bibata Cursor source

```bash
git clone https://github.com/ful1e5/Bibata_Cursor.git ~/src/Bibata_Cursor
cd ~/src/Bibata_Cursor && npm install
```

### 3. Set up Python environment

```bash
python3 -m venv ~/.local/bibata-venv
~/.local/bibata-venv/bin/pip install clickgen toml
```

### 4. Install the scripts

```bash
# Copy main script
cp omarchy-sync-cursor ~/.local/bin/
cp cursor-sync ~/.local/bin/
chmod +x ~/.local/bin/omarchy-sync-cursor ~/.local/bin/cursor-sync

# Create config directory and copy config
mkdir -p ~/.config/bibata-omarchy-sync
cp config.example.toml ~/.config/bibata-omarchy-sync/config.toml

# Install the theme-set hook for automatic syncing
cp hooks/theme-set.example ~/.config/omarchy/hooks/theme-set
chmod +x ~/.config/omarchy/hooks/theme-set
```

### 5. Add cursor config to Hyprland

Add this line to your `~/.config/hypr/hyprland.conf`:

```bash
source = ~/.config/hypr/cursor-auto.conf
```

## Usage

### GUI Color Picker

Launch the interactive color picker with full preset support:

```bash
cursor-sync --picker
```

**GUI Features:**
- 🎨 **HSV Color Controls** - Hue bar + saturation/value pad
- 🔤 **Hex Input** - Direct hex color entry
- 🎯 **Persistent Presets** - Save and reuse favorite colors (right-click to remove)
- 🎲 **Random Color** - Generate vibrant random colors
- 👁️ **Live Cursor Preview** - See cursor in real-time with selected color
- ⚡ **Transparency Presets** - Select glass, neon, shadow, or classic effects

### Manual sync

```bash
# Sync cursor to a specific theme (auto-detects transparency)
cursor-sync catppuccin-mocha

# Preview what colors would be used (no changes)
cursor-sync one-dark-pro --dry-run

# Force rebuild even if cached
cursor-sync crimson --force

# Use specific transparency preset
cursor-sync gruvbox --transparency glass
cursor-sync tokyo-night --transparency neon
cursor-sync nord --transparency classic
```

### Automatic sync

Once the hook is installed, cursors sync automatically when you change themes:

```bash
omarchy-theme-set velvetnight
# Cursor automatically updates to match!
```

## Configuration

Edit `~/.config/bibata-omarchy-sync/config.toml`:

```toml
[paths]
# Path to Bibata cursor source
bibata_source_dir = "~/src/Bibata_Cursor"

# Cache directory for built themes
cache_dir = "~/.local/share/bibata-omarchy-cache"

[cursor]
# Cursor size (24, 32, 48, etc.)
size = 24

# SVG style: "modern" (rounded) or "original" (sharp)
style = "modern"

[color_mapping]
# Which theme color to use for cursor base
# Options: "cursor", "magenta", "cyan", "blue", "accent"
base_color_source = "cursor"
base_color_fallback = "magenta"

# Outline color source
# Options: "background", "black", "auto_contrast"
outline_color_source = "background"

[transparency]
# "auto" (default), "glass", "shadow", "neon", or "classic"
preset = "auto"
```

## Color Selection Algorithm

The tool uses an intelligent algorithm to select aesthetically pleasing cursor colors:

### Base Color (cursor fill)
1. Uses the theme's cursor color if defined and distinct
2. Falls back to vibrant accent colors (magenta → cyan → blue)
3. Prefers colors with good contrast against the background
4. For monochrome themes, uses foreground color

### Outline Color (cursor border)
1. Uses background color by default
2. Automatically adjusts for minimum contrast ratio (3.5:1)
3. Darkens/lightens as needed for visibility

### Watch Color (loading animation)
1. Uses a darkened version of background
2. Ensures good visibility for animation states

## Transparency Presets

The tool includes an intelligent theme-aware transparency system that automatically adapts cursor effects to match your theme.

**All presets are cached independently**, so switching between them is instant:

```bash
cursor-sync catppuccin-mocha                      # ~15s first build with auto-detected preset
cursor-sync catppuccin-mocha --transparency neon  # ~15s first time, then instant on future use
cursor-sync catppuccin-mocha --transparency glass # ~15s first time, then instant on future use
cursor-sync catppuccin-mocha                      # Instant - uses cached version
```

Each theme + preset combination is cached separately in `~/.local/share/icons/`, so:
- `Bibata-Omarchy-catppuccin-mocha` (no preset suffix = default/classic)
- `Bibata-Omarchy-catppuccin-mocha-glass` (glass preset)
- `Bibata-Omarchy-catppuccin-mocha-neon` (neon preset)
- `Bibata-Omarchy-catppuccin-mocha-shadow` (shadow preset)

### Preset Types

- **GLASS** (default for dark themes): 75% opacity, polished semi-transparent look
  - Best for modern, colorful dark themes
  - Creates a clean, sophisticated aesthetic
  - Slight transparency makes the underlying content subtly visible

- **SHADOW** (alternative): 95% opacity, nearly opaque
  - Best for minimal or high-contrast dark themes
  - Maintains maximum cursor definition and visibility
  - Subtle shadow-like appearance without transparency

- **NEON** (dark vibrant themes): 60% opacity, more transparent with glow effect
  - Best for dark themes with vibrant colors
  - Gaming-oriented and cyberpunk aesthetic
  - More pronounced transparency for futuristic look

- **CLASSIC** (light themes & accessibility): 100% opacity, fully opaque
  - Always used for light themes (transparency breaks visibility)
  - Falls back for accessibility requirements
  - Maximum cursor contrast and visibility

### Auto-Detection

By default, the preset is automatically selected based on theme properties:

```
Dark theme + Highly saturated background → NEON
Dark theme (most cases)                  → GLASS
Light theme                              → CLASSIC
```

### Configuration

Set in `config.toml`:

```toml
[transparency]
# "auto" (default), "glass", "shadow", "neon", or "classic"
preset = "auto"
```

Or override via CLI:

```bash
cursor-sync my-theme --transparency glass
cursor-sync my-theme --transparency neon
```

## Feature Comparison: CLI vs GUI

| Feature | CLI | GUI |
|---------|-----|-----|
| **Color Selection** | `--base-color`, `--outline-color`, `--watch-color` | ✓ Full HSV + hex input |
| **Transparency Presets** | `--transparency` auto/glass/neon/shadow/classic | ✓ Preset buttons |
| **Theme Selection** | `<theme_name>` positional arg | ✗ Use CLI instead |
| **Random Color** | `--random` flag | ✓ Random button |
| **Color Presets** | Config file only | ✓ Persistent swatch grid |
| **Dry-run Mode** | `--dry-run` flag | ✗ Use CLI instead |
| **Force Rebuild** | `--force` flag | ✗ Use CLI instead |
| **Current Theme** | `--current` flag | ✗ Use CLI instead |
| **Cursor Preview** | Log output only | ✓ Live preview |

**Recommended Usage:**
- **GUI (`--picker`)**: Perfect for picking colors with live preview and transparency effects
- **CLI**: For automation, theme-based workflows, and advanced options

## File Locations

| File | Purpose |
|------|---------|
| `~/.local/bin/omarchy-sync-cursor` | Main Python script |
| `~/.local/bin/cursor-sync` | Bash wrapper |
| `~/.config/bibata-omarchy-sync/config.toml` | Configuration |
| `~/.config/omarchy/hooks/theme-set` | Auto-sync hook |
| `~/.config/hypr/cursor-auto.conf` | Generated Hyprland config |
| `~/.local/share/bibata-omarchy-cache/` | Build cache |
| `~/.local/share/icons/Bibata-Omarchy-*` | Installed cursor themes |

## Troubleshooting

### Cursor doesn't change

1. Check if the hook ran: `cat ~/.local/share/bibata-omarchy-cache/hook.log`
2. Verify Hyprland sources the config: `grep cursor-auto ~/.config/hypr/hyprland.conf`
3. Try manual sync: `cursor-sync <theme-name>`

### Build fails

1. Ensure Bibata repo is set up: `ls ~/src/Bibata_Cursor/svg/`
2. Check npm dependencies: `cd ~/src/Bibata_Cursor && npm install`
3. Verify Python venv: `~/.local/bibata-venv/bin/pip list | grep clickgen`

### Colors look wrong

1. Check theme colors: `cat ~/.config/omarchy/themes/<theme>/alacritty.toml`
2. Preview computed colors: `cursor-sync <theme> --dry-run`
3. Adjust `config.toml` color mapping settings

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                    omarchy-theme-set                            │
│                          │                                      │
│                          ▼                                      │
│            ~/.config/omarchy/hooks/theme-set                    │
│                          │                                      │
│                          ▼                                      │
│                   cursor-sync <theme>                           │
│                          │                                      │
│         ┌────────────────┼────────────────┐                     │
│         ▼                ▼                ▼                     │
│   Parse colors     Check cache     Build if needed              │
│   from theme         │                    │                     │
│         │            ▼                    ▼                     │
│         │      Hit? → Apply         cbmp → ctgen                │
│         │                                 │                     │
│         └─────────────────────────────────┘                     │
│                          │                                      │
│                          ▼                                      │
│              Apply cursor everywhere:                           │
│         • hyprctl setcursor                                     │
│         • HYPRCURSOR_THEME env                                  │
│         • XCURSOR_THEME env                                     │
│         • gsettings (GTK)                                       │
└─────────────────────────────────────────────────────────────────┘
```

## Credits

- [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor) by @ful1e5
- [Omarchy](https://omarchy.org) - The Arch + Hyprland distribution

## License

MIT License - See [LICENSE](LICENSE) for details.
