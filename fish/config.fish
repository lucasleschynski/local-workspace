/opt/homebrew/bin/brew shellenv | source

# ------------------------------------------------------------
# FISH CONFIG
# ------------------------------------------------------------

set -gx fish_prompt_pwd_dir_length 3

# ------------------------------------------------------------
# PATH
# ------------------------------------------------------------

# VS Code CLI
fish_add_path --append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Neovim
# NOTE: This preserves your original relative path.
# If nvim-macos-arm64 is actually in your home directory,
# change this to: fish_add_path "$HOME/nvim-macos-arm64/bin"
set -gx PATH ./nvim-macos-arm64/bin $PATH

# Homebrew libraries
set -gx LIBRARY_PATH /opt/homebrew/lib

# Preserved from your zsh config.
# This is probably unnecessary because /opt/homebrew/opt contains
# formula directories rather than executables.
fish_add_path /opt/homebrew/opt

# ------------------------------------------------------------
# C / C++
# ------------------------------------------------------------

set -gx CPATH /opt/homebrew/include
set -gx LDFLAGS "-L/opt/homebrew/lib"
set -gx CPPFLAGS "-I/opt/homebrew/include"

# Preserve any existing C++ include paths.
set -gx CPLUS_INCLUDE_PATH /opt/homebrew/include $CPLUS_INCLUDE_PATH

# ------------------------------------------------------------
# pnpm
# ------------------------------------------------------------

set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path "$PNPM_HOME"

# ------------------------------------------------------------
# Bun
# ------------------------------------------------------------

set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

# Do NOT source ~/.bun/_bun here.
# That file is a Zsh completion script and is not valid Fish syntax.
#
# Once you're running Fish, reinstall/generate Bun's Fish completions with:
#
#   bun completions
#
# Bun supports Fish completions directly.

# ------------------------------------------------------------
# Rust / Cargo
# ------------------------------------------------------------

fish_add_path "$HOME/.cargo/bin"

# ------------------------------------------------------------
# opam / OCaml
# ------------------------------------------------------------

# Prefer Fish's native opam initialization.
if test -r "$HOME/.opam/opam-init/init.fish"
    source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>/dev/null
end

# ------------------------------------------------------------
# NVM
# ------------------------------------------------------------

# nvm itself does NOT natively support Fish.
#
# If you install "bass", this wrapper lets you continue using your
# existing ~/.nvm installation:
#
#   fisher install edc/bass
#
# Then uncomment:
#
# function nvm
#     bass source "$HOME/.nvm/nvm.sh" --no-use ';' nvm $argv
# end

# ------------------------------------------------------------
# Interactive shell startup
# ------------------------------------------------------------

if status is-interactive
    clear
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
