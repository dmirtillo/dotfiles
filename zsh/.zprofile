
if command -v brew &>/dev/null; then
  eval "$(brew shellenv zsh)"
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
