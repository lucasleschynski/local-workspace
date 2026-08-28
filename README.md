# workspace

Portable machine settings. Credentials stay off GitHub.

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

Not included (machine-local / secret):

- `~/.pi/agent/auth.json` — provider tokens; run `/login` on a new machine
- `~/.pi/grok-cli/accounts.json`
- `fish_variables` — universal vars / machine paths
- Ghostty `auto/` — GUI-generated theme include
- sessions, model cache, npm installs

Grass is the shared theme across Ghostty, Zed, and pi.

## New laptop

```bash
git clone git@github.com:lucasleschynski/pi-config.git ~/pi-config
cd ~/pi-config
./install.sh
```

Then install pi, open it, and `/login` for xAI.

## After changing settings here

```bash
cd ~/pi-config
git add -A
git commit -m "update config"
git push
```

On another machine: `git pull && ./install.sh`.
