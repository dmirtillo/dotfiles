# Brewfile Syncing and Preservation

## Requirements

- Local Homebrew state (`brew bundle dump`) must be accurately merged into tracking files.
- Manual comments, headers, and grouping in tracking files (like the `Brewfile`) MUST NOT be destroyed by auto-generation commands.

## How to Build It

To sync a local `Brewfile` with newly installed local packages without losing manual annotations:

1.  **Extract Local State Cleanly:**
    Use `brew bundle dump --file=-` to capture the current explicit installations in memory or a temp file. This creates a standard Homebrew format stream.

2.  **Merge via Script (Do Not Overwrite):**
    Use a bash script to compare the extracted state against the existing `Brewfile` line by line.

    ```bash
    # Extract just the new lines (simplified example)
    while read -r line; do
      [ -z "$line" ] && continue
      escaped_line=$(echo "$line" | sed 's/"/\\"/g' | sed 's/\./\\./g')
      
      if ! grep -q "^$escaped_line" "$TARGET_BREWFILE"; then
        echo "$line" >> "$TARGET_BREWFILE"
      fi
    done < "$DUMP_FILE"
    ```

3.  **Append to an "Uncategorized" Section:**
    Instead of inserting arbitrarily, append the newly discovered dependencies to a designated section at the bottom of the `Brewfile` (e.g., `# NEWLY INSTALLED (UNCATEGORIZED)`). This maintains order and allows the user to manually categorize them later.

## What to Avoid

-   **Avoid `brew bundle dump --file=Brewfile --force`.** This command is completely destructive to file structure. It strips all manual comments (like `# tracks v1.15.11`) and alphabetizes the entire file purely by package type.

## Constraints

-   The merge approach currently only *adds* missing dependencies. If a user uninstalls a package locally, the merge script does not automatically remove it from the `Brewfile` (though this logic could be added).

## Origin

Synthesized from spikes: 004, 005, 006
Source files available in: `sources/004-brew-list-parsing/`, `sources/005-brewfile-sync/`, `sources/006-brewfile-sync-preserve-comments/`
