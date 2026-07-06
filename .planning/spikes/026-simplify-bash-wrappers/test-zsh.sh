#!/usr/bin/env zsh
echo "Testing Zsh modifier..."
mkdir -p dummy_keys
touch dummy_keys/key1.key dummy_keys/key2.key
keys=(${$(ls dummy_keys/*.key 2>/dev/null):t:r})
echo "Extracted keys: $keys"
rm -rf dummy_keys
