# pi-config

Portable pi + zsh prompt settings. Credentials stay off GitHub.

## What's here

| Path | Goes to |
|------|---------|
| `pi/settings.json` | `~/.pi/agent/settings.json` |
| `pi/extensions/` | `~/.pi/agent/extensions/` |
| `pi/themes/grass.json` | `~/.pi/agent/themes/grass.json` |
| `zsh/gnzh.zsh-theme` | `~/.oh-my-zsh/custom/themes/gnzh.zsh-theme` |

Not included (machine-local / secret):

- `~/.pi/agent/auth.json` — provider tokens; run `/login` on a new machine
- `~/.pi/grok-cli/accounts.json`
- sessions, model cache, npm installs

Ghostty's Grass theme is built in. Set it in Ghostty if it isn't already.

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
