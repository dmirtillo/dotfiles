# Enable Powerlevel10k instant prompt. Should stay at the very top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure PATH entries are unique (auto-deduplication)
typeset -U path

# OPENSPEC:START
# OpenSpec shell completions configuration - fpath only, compinit handled by use-omz
fpath=("/Users/dmirtillo/.zsh/completions" $fpath)
# OPENSPEC:END

# Powerlevel10k shell integration
typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

alias python=python3

# Homebrew environment (cached to ~/.cache/brew-shellenv.zsh for speed)
# Auto-regenerates when Homebrew is updated -- no manual maintenance needed
_brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
_brew_bin="/opt/homebrew/bin/brew"
if [[ ! -f "$_brew_cache" ]] || [[ "$_brew_bin" -nt "$_brew_cache" ]]; then
  "$_brew_bin" shellenv > "$_brew_cache" 2>/dev/null
fi
source "$_brew_cache"
unset _brew_cache _brew_bin

# Skip OMZ compaudit security check (safe on single-user machine, saves ~16ms)
export ZSH_DISABLE_COMPFIX=true

# Disable OMZ magic functions (url pasting slowdown fix from HN discussion)
export DISABLE_MAGIC_FUNCTIONS=true

# Autosuggestions performance tweaks (set before plugin loads)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# NVM lazy-loading config (zsh-nvm plugin loads nvm only on first use)
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_DIR="$HOME/.nvm"

# ============================================================================
# ANTIDOTE - Plugin Manager
# ============================================================================
# Source antidote from Homebrew
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

# Lazy-load: generate static file only when plugins.txt changes
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

# NOTE: compinit is handled by getantidote/use-omz (deferred compinit).
# Do NOT call compinit again here -- it was the #1 bottleneck (~250ms).

# PATH setup (consolidated, typeset -U path prevents duplicates)
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

alias tfswitch='tfswitch -b $HOME/.local/bin/terraform'

load-tfswitch() {
	local tfswitchrc_path=".terraform-version"

	if [ -f "$tfswitchrc_path" ]; then
	tfswitch
	fi
}
add-zsh-hook chpwd load-tfswitch
load-tfswitch

# You may need to manually set your language environment
export LANG=en_GB.UTF-8

# Preferred editor
export EDITOR='vim'

# curl (using HOMEBREW_PREFIX for correct architecture path)
export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/curl/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/curl/include"
export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"

#azure-cli
#autoload bashcompinit && bashcompinit
#source $(brew --prefix)/etc/bash_completion.d/az

# Set up fzf key bindings and fuzzy completion (cached for speed)
# Auto-regenerates when fzf is updated via Homebrew -- no manual maintenance needed
_fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf.zsh"
_fzf_bin="$(whence -p fzf)"
if [[ -n "$_fzf_bin" ]] && { [[ ! -f "$_fzf_cache" ]] || [[ "$_fzf_bin" -nt "$_fzf_cache" ]]; }; then
  fzf --zsh > "$_fzf_cache" 2>/dev/null
fi
[[ -f "$_fzf_cache" ]] && source "$_fzf_cache"
unset _fzf_cache _fzf_bin

# SSH Agent Configuration
# Start ssh-agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Function to load default keys
load_default_ssh_keys() {
    # Define your commonly used keys
    local default_keys=(
        "dmirtillo-gitlab-arsenalia.key"
        "frocetti.key"
        "dmirtillo-actabaseadmin-ed25519.key"
    )
    
    for key in "${default_keys[@]}"; do
        local key_path="$HOME/.ssh/keys/$key"
        if [ -f "$key_path" ]; then
            # Check if key is already loaded
            if ! ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf "$key_path" 2>/dev/null | awk '{print $2}')"; then
                ssh-add "$key_path" 2>/dev/null
            fi
        fi
    done
}

# Function to add any key on demand
ssh_add_key() {
    local key_name="$1"
    local key_path
    
    if [ -z "$key_name" ]; then
        echo "Usage: ssh_add_key <key_name>"
        echo "Available keys:"
        ls ~/.ssh/keys/*.key 2>/dev/null | xargs -n1 basename | sed 's/\.key$//'
        return 1
    fi
    
    # Try with .key extension first
    key_path="$HOME/.ssh/keys/${key_name}.key"
    if [ ! -f "$key_path" ]; then
        # Try without extension
        key_path="$HOME/.ssh/keys/$key_name"
    fi
    
    if [ -f "$key_path" ]; then
        ssh-add "$key_path"
        echo "Added key: $key_path"
    else
        echo "Key not found: $key_name"
        echo "Available keys:"
        ls ~/.ssh/keys/*.key 2>/dev/null | xargs -n1 basename | sed 's/\.key$//'
    fi
}

# Auto-completion for ssh_add_key function
_ssh_add_key_completion() {
    local keys=($(ls ~/.ssh/keys/*.key 2>/dev/null | xargs -n1 basename | sed 's/\.key$//'))
    compadd -a keys
}
compdef _ssh_add_key_completion ssh_add_key

# Load SSH keys in background to avoid blocking shell startup (~11ms saved)
load_default_ssh_keys &!

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#alias gam="/Users/dmirtillo/bin/gam7/gam"

# >>> conda initialize >>>
# Uncomment below to enable conda (managed by 'conda init')
#__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

# JetBrains VM options
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then 
  . "${___MY_VMOPTIONS_SHELL_FILE}"
fi

# VS Code Shell Integration (hardcoded path avoids 255ms Electron fork)
# This path is stable across VS Code updates; falls back to dynamic lookup if missing
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  _vscode_si="/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh"
  if [[ -f "$_vscode_si" ]]; then
    . "$_vscode_si"
  else
    . "$(code --locate-shell-integration-path zsh)"
  fi
  unset _vscode_si
fi

export GOOGLE_GENAI_USE_VERTEXAI=true
export GOOGLE_CLOUD_PROJECT="actabase-vertexai"
export GOOGLE_CLOUD_LOCATION="global"

# ============================================================================
# PRODUCTIVITY ALIASES AND FUNCTIONS
# ============================================================================

# File and Directory Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Enhanced ls commands (using eza, a modern ls replacement you have installed)
alias ls='eza --color=auto --icons'
alias ll='eza -alF --icons --git'    # Long listing with git status
alias la='eza -a --icons'
alias l='eza -F --icons'
alias lt='eza -l --sort=modified'    # Sort by time, newest last
alias lh='eza -l --icons'            # Human readable sizes (eza default)
alias lsize='eza -l --sort=size'     # Sort by size
alias ltree='eza --tree --level=2 --icons'  # Tree view with eza

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'

# Tree view (if you have tree installed: brew install tree)
alias tree='tree -C'
alias t1='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'

# Quick access to common directories
alias desktop='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias projects='cd ~/projects'

# Git Enhancements (beyond what oh-my-zsh provides)
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias glog='git log --oneline --graph --decorate'
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gwip='git add -A && git commit -m "WIP"'
alias gunwip='git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'
alias gundo='git reset --soft HEAD~1'

# Development Tools

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
#alias activate='source venv/bin/activate'
#alias deactivate='deactivate'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'

# Docker shortcuts (using docker compose v2)
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcr='docker compose restart'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -f'

# System Utilities
alias psg='procs --tree'       # procs: modern ps with tree view (grep with procs -W keyword)
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias ports='netstat -tuln'
alias listening='lsof -i -P | grep LISTEN'

# File operations with safety
alias cp='cp -i'    # Confirm before overwriting
alias mv='mv -i'    # Confirm before overwriting
alias rm='rm -i'    # Confirm before deleting
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

# Disk usage (using modern replacements you have installed)
alias du='dust'              # dust: intuitive disk usage with bar chart
alias df='duf'               # duf: colorful disk free with table layout
alias ducks='dust -r -n 10'  # Show largest directories
alias diskspace='duf'

# macOS Specific
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup='sudo rm -rf ~/.Trash/*'
alias flushdns='sudo dscacheutil -flushcache'
alias emptytrash='sudo rm -rfv ~/.Trash'

# Quick edit common files
alias zshrc='code ~/.zshrc'
alias hosts='sudo code /etc/hosts'
alias sshconfig='code ~/.ssh'

# History aliases
alias h='history'
alias hg='history | grep'
alias hs='history | grep'

# Process management
kport() {
    if [ -z "$1" ]; then
        echo "Usage: kport <port_number>"
        echo "Example: kport 3000"
        return 1
    fi
    
    local pids=$(lsof -ti:$1)
    if [ -z "$pids" ]; then
        echo "No process found running on port $1"
        return 1
    fi
    
    echo "Killing processes on port $1: $pids"
    echo $pids | xargs kill -9
    echo "Done!"
}

# Alternative alias for killport
alias killport='kport'

# ============================================================================
# USEFUL FUNCTIONS
# ============================================================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files by name (using fd, a modern find replacement you have installed)
findfile() {
    fd --type f "$1"
}

# Find directories by name
finddir() {
    fd --type d "$1"
}

# Weather function
weather() {
    local location=${1:-"Rome"}
    curl -s "wttr.in/$location"
}

# Quick backup function
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Git clone and cd into directory
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick note taking
note() {
    echo "$(date): $*" >> ~/notes.txt
}

# Show notes
notes() {
    cat ~/notes.txt
}

# Quick search in files (uses ripgrep for speed)
search() {
    rg "$1" .
}

# Show file size in human readable format
sizeof() {
    du -sh "$1"
}

# ============================================================================
# ENHANCED HISTORY SETTINGS
# ============================================================================
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# ============================================================================
# ADDITIONAL PRODUCTIVITY SETTINGS
# ============================================================================

# Auto-correction (commands only, not arguments)
setopt CORRECT

# Better completion
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ============================================================================
# MODERN TOOL INTEGRATIONS
# You have these installed via brew but weren't using them in your shell.
# Based on your history: heavy use of cat, grep, find, ssh, ansible, terraform
# ============================================================================

# bat: syntax-highlighted cat replacement (you use cat 31x in history)
alias cat='bat --paging=never'
alias catp='bat'                   # with pager (like less but with syntax highlighting)
alias batdiff='git diff --name-only --diff-filter=d | xargs bat --diff'

# Helper: cache a tool's init output, auto-regenerate when binary updates
_cache_eval() {
  local name="$1" cmd="$2"
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/${name}.zsh"
  local bin="$(whence -p "$name")"
  if [[ -n "$bin" ]] && { [[ ! -f "$cache" ]] || [[ "$bin" -nt "$cache" ]]; }; then
    eval "$cmd" > "$cache" 2>/dev/null
  fi
  [[ -f "$cache" ]] && source "$cache"
}

# zoxide: smarter cd that learns from your habits (replaces OMZ z plugin)
_cache_eval zoxide 'zoxide init zsh'
alias cd='z'                       # seamless replacement, learns directories
alias cdi='zi'                     # interactive directory picker with fzf

# direnv: auto-load .envrc per directory (useful for terraform/ansible projects)
_cache_eval direnv 'direnv hook zsh'

# thefuck: correct previous command typos (type 'fuck' after a mistake)
_cache_eval thefuck 'thefuck --alias'

# lazygit: TUI for git (you use git 83x in history)
alias lg='lazygit'

# lazydocker: TUI for docker (you use docker 32x in history)
alias lzd='lazydocker'

# Terraform shortcuts (you use terraform 48x in history)
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfs='terraform show'
alias tfo='terraform output'
alias tfv='terraform validate'
alias tfw='terraform workspace'

# Ansible shortcuts (your #1 tool -- 130x in history)
alias ap='ansible-playbook'
alias apv='ansible-playbook --ask-vault-pass'
alias apc='ansible-playbook --check --diff'   # dry run with diff
alias av='ansible-vault'
alias ave='ansible-vault encrypt'
alias avd='ansible-vault decrypt'
alias avv='ansible-vault view'
alias al='ansible-lint'
alias ai='ansible-inventory --graph'

# gping: graphical ping (you use ping 4x in history)
alias ping='gping'

# tldr: simplified man pages (quicker than man for common usage)
alias help='tldr'

# ncdu: interactive disk usage explorer
alias diskexplore='ncdu'

# bottom: system monitor TUI (like htop but better)
alias btm='btm'
alias sysmon='btm'

# Upgrade everything: brew formulae + casks + antidote plugins in one command
alias brewup='brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup && antidote update'

# ============================================================================
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# Added by Antigravity
export PATH="/Users/dmirtillo/.antigravity/antigravity/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
