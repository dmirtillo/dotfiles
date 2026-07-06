#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

cp ../../../Brewfile dummy_Brewfile
cp ../../../Pacfile dummy_Pacfile

echo "Original Brewfile lines: $(wc -l < dummy_Brewfile)"
echo "Original Pacfile lines: $(wc -l < dummy_Pacfile)"

# Remove from Brewfile
sed -i.bak -E '/brew "(node|go|nvm|jenv|zplug|tree|htop|btop)"/d' dummy_Brewfile

# Remove from Pacfile
sed -i.bak -E '/^(nodejs|go|nvm|jenv|zplug|tree|htop|btop)$/d' dummy_Pacfile

echo "Stripped Brewfile lines: $(wc -l < dummy_Brewfile)"
echo "Stripped Pacfile lines: $(wc -l < dummy_Pacfile)"

diff -u ../../../Brewfile dummy_Brewfile || true
diff -u ../../../Pacfile dummy_Pacfile || true
