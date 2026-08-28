# workspace

My settings for local dev tools, including the slightly imperfect Grass theme I ported from ghostty to pi and zed.

## What's here

| Path | Goes to |
|------|---------|
| `pi/settings.json` | `~/.pi/agent/settings.json` |
| `pi/extensions/` | `~/.pi/agent/extensions/` |
| `pi/themes/grass.json` | `~/.pi/agent/themes/grass.json` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `ghostty/config.ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| `ghostty/themes/Grass` | same dir, `themes/Grass` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `zed/themes/grass.json` | `~/.config/zed/themes/grass.json` |

On Linux, Ghostty links into `~/.config/ghostty/` instead.

Grass is the shared theme across Ghostty, Zed, and pi.

## How to

```bash
git clone git@github.com:lucasleschynski/pi-config.git ~/pi-config
cd ~/pi-config
./install.sh
```

Then install pi, open it, and `/login`
