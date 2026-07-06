#!/usr/bin/env bash
set -e

echo "Checking commands directory..."
ls ~/.config/opencode/command/gsd-*.md | wc -l

echo "Checking if gsd-spike command exists..."
ls ~/.config/opencode/command/gsd-spike.md

echo "Checking if skills exist..."
ls ~/.config/opencode/skills/gsd-*.md | wc -l
