#!/usr/bin/env bash

# Test dumping the current brew state
echo "Running brew bundle dump..."
brew bundle dump --file=-
