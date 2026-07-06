#!/bin/bash
echo "Checking OpenCode configuration for Ponytail..."
cat ~/.config/opencode/opencode.json | grep ponytail
echo ""
echo "Checking if Ponytail plugin is installed..."
ls -l ~/.config/opencode/node_modules/@dietrichgebert/ponytail 2>/dev/null || echo "Not found in node_modules"
echo ""
echo "Checking Ponytail config..."
cat ~/.config/ponytail/config.json 2>/dev/null || echo "No ponytail config.json found"
