# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "(/opt/homebrew/bin/brew shellenv)"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::common-aliases
zinit snippet OMZP::alias-finder

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias copy-last='fc -ln -1 | sed "s/^[[:space:]]*//" | pbcopy'
alias gchanged='git diff --name-only $(git_main_branch)...'
alias lg='lazygit'
alias gmr='glab mr create -a s.el-farissi'

# Alias discovery helpers
_alias_viewer() {
  if ! command -v jless >/dev/null 2>&1; then
    echo "jless is not installed. Install it with: brew install jless" >&2
    return 1
  fi

  jless
}

_alias_topic_classifier_py() {
  cat <<'PY'
import re

def classify(command):
    normalized = command.strip().strip("'").strip('"')

    if normalized.startswith(('docker-compose ', 'docker compose ')) or normalized in ('docker-compose', 'docker compose') or re.search(r'\bdocker(?:-compose| compose)\b', normalized):
        return 'docker compose'
    if normalized.startswith('docker ') or normalized == 'docker' or re.search(r'\bdocker\b', normalized):
        return 'docker'
    if normalized.startswith(('git ', 'lazygit ')) or normalized in ('git', 'lazygit') or re.search(r'\bgit\b', normalized):
        return 'git'
    if normalized.startswith('kubectl ') or normalized == 'kubectl' or re.search(r'\bkubectl\b', normalized):
        return 'kubectl'
    if normalized.startswith(('kubectx ', 'kubens ')) or normalized in ('kubectx', 'kubens') or re.search(r'\b(kubectx|kubens)\b', normalized):
        return 'kubectx'
    if normalized.startswith(('nvim ', 'vim ', 'vi ')) or normalized in ('nvim', 'vim', 'vi') or re.search(r'\b(nvim|vim|vi)\b', normalized):
        return 'editor'
    if normalized.startswith('|') or ' | ' in normalized or normalized.startswith('2>&1') or normalized.startswith('1>') or normalized.startswith('>'):
        return 'shell'

    return 'other'
PY
}

_aliases_json() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required to format aliases as JSON." >&2
    return 1
  fi

  local pattern="${1:-.*}"
  local name

  {
    for name in ${(kon)aliases}; do
      if [[ "$name" =~ "$pattern" ]]; then
        print -rn -- "$name"$'\0'"${aliases[$name]}"$'\0'
      fi
    done
  } | python3 -c "$(cat <<PY
import json
import sys
from collections import OrderedDict

$(_alias_topic_classifier_py)

parts = sys.stdin.buffer.read().split(b"\0")
if parts and parts[-1] == b"":
    parts.pop()

groups = OrderedDict()
for i in range(0, len(parts), 2):
    name = parts[i].decode()
    command = parts[i + 1].decode()
    topic = classify(command)
    groups.setdefault(topic, []).append({
        'name': name,
        'command': command,
    })

print(json.dumps(groups, indent=2))
PY
)"
}

aliases() {
  _aliases_json | _alias_viewer
}

git-aliases() {
  _aliases_json '^g' | _alias_viewer
}

omz-aliases() {
  local plugin="${1:-git}"
  local snippet="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/snippets/OMZP::${plugin}/OMZP::${plugin}"

  if [[ ! -r "$snippet" ]]; then
    echo "OMZ snippet not found: $snippet" >&2
    return 1
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required to format aliases as JSON." >&2
    return 1
  fi

  python3 - "$plugin" "$snippet" <<PY | _alias_viewer
import json
import re
import sys
from collections import OrderedDict

$(_alias_topic_classifier_py)

plugin, snippet = sys.argv[1], sys.argv[2]
groups = OrderedDict()
with open(snippet) as source:
    for line in source:
        match = re.match(r"^alias\s+([^=]+)=(.*)$", line.strip())
        if match:
            command = match.group(2)
            topic = classify(command)
            groups.setdefault(topic, []).append({
                'plugin': plugin,
                'name': match.group(1),
                'command': command,
            })

print(json.dumps(groups, indent=2))
PY
}

# psql util
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Created by `pipx` on 2024-08-31 14:39:16
export PATH="$PATH:/Users/salah/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
. "/Users/salah/.deno/env"

# Minikube completions
if command -v minikube &>/dev/null; then
  source <(minikube completion zsh)
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/salah/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Enable uv shell completions
eval "$(uv generate-shell-completion zsh)"

# NVim
export PATH="/usr/local/nvim/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/mc mc

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
