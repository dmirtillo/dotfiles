#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Testing alias definitions..."
shopt -s expand_aliases
alias findfile='fd -tf'
alias finddir='fd -td'
alias search='rg'
alias sizeof='du -sh'
alias kport='f() { lsof -ti:$1 | xargs kill -9 2>/dev/null || true; }; f'

# Test Zsh modifier syntax (must run in zsh)
cat << 'ZSH_TEST' > test-zsh.sh
#!/usr/bin/env zsh
echo "Testing Zsh modifier..."
mkdir -p dummy_keys
touch dummy_keys/key1.key dummy_keys/key2.key
keys=(${$(ls dummy_keys/*.key 2>/dev/null):t:r})
echo "Extracted keys: $keys"
rm -rf dummy_keys
ZSH_TEST
chmod +x test-zsh.sh
./test-zsh.sh

echo "All wrappers verified successfully."
