#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
pi_home="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
zsh_theme_dir="$HOME/.oh-my-zsh/custom/themes"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      return
    fi
    rm -rf "$dest"
  fi
  ln -s "$src" "$dest"
}

mkdir -p "$pi_home/extensions" "$pi_home/themes"

link "$root/pi/settings.json" "$pi_home/settings.json"
for f in "$root/pi/extensions/"*.ts; do
  link "$f" "$pi_home/extensions/$(basename "$f")"
done
for f in "$root/pi/themes/"*.json; do
  link "$f" "$pi_home/themes/$(basename "$f")"
done

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  link "$root/zsh/gnzh.zsh-theme" "$zsh_theme_dir/gnzh.zsh-theme"
else
  echo "oh-my-zsh not found; skipped zsh theme"
fi

echo "Linked pi config into $pi_home"
echo "Log in with /login — auth.json is not in this repo."
