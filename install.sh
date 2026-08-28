#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
pi_home="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
fish_home="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
zed_home="${XDG_CONFIG_HOME:-$HOME/.config}/zed"

if [[ "$(uname -s)" == Darwin ]]; then
  ghostty_home="$HOME/Library/Application Support/com.mitchellh.ghostty"
else
  ghostty_home="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
fi

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

link_files() {
  local src_dir="$1" dest_dir="$2"
  local f
  mkdir -p "$dest_dir"
  for f in "$src_dir"/*; do
    [[ -f "$f" ]] || continue
    link "$f" "$dest_dir/$(basename "$f")"
  done
}

mkdir -p "$pi_home/extensions" "$pi_home/themes"

link "$root/pi/settings.json" "$pi_home/settings.json"
link_files "$root/pi/extensions" "$pi_home/extensions"
link_files "$root/pi/themes" "$pi_home/themes"

link "$root/fish/config.fish" "$fish_home/config.fish"

link "$root/ghostty/config.ghostty" "$ghostty_home/config.ghostty"
link_files "$root/ghostty/themes" "$ghostty_home/themes"

link "$root/zed/settings.json" "$zed_home/settings.json"
link_files "$root/zed/themes" "$zed_home/themes"

echo "Linked workspace config:"
echo "  pi      -> $pi_home"
echo "  fish    -> $fish_home"
echo "  ghostty -> $ghostty_home"
echo "  zed     -> $zed_home"
echo "Log in to pi with /login — auth.json is not in this repo."
