# gnzh, recolored for Ghostty Grass (#13773d forest green).
# Warm parchment + apricot sit on the green without collapsing into it.

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

if [[ $UID -ne 0 ]]; then
  PR_USER='%F{#f0e4b8}%n%f'
  PR_USER_OP='%F{#f0e4b8}%#%f'
  PR_PROMPT='%f❯ %f'
else
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}❯ %f'
fi

if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f'
else
  PR_HOST='%F{#f0e4b8}%m%f'
fi

local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{#f0e4b8}@${PR_HOST}"
local current_dir="%B%F{#f4b183}%~%f%b"
local git_branch='$(git_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

PROMPT="╭─${venv_prompt}${user_host} ${current_dir} \$(ruby_prompt_info) ${git_branch}
╰─$PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{#e7b000}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"
ZSH_THEME_VIRTUALENV_PREFIX="%F{red}("
ZSH_THEME_VIRTUALENV_SUFFIX=")%f "

}
