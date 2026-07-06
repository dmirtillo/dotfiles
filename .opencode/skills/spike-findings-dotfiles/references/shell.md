# Shell Configuration

## Requirements

- Rely on Zsh native features and core aliases instead of reinventing standard tools.
- Optimize line count and functionality with `ponytail` mindset.

## How to Build It

- Use simple aliases over complex Bash functions when conditional logic is not needed.
  - `alias extract='tar -xf'`
  - `alias findfile='fd -tf'`
  - `alias kport='lsof -ti:$1 | xargs kill -9 2>/dev/null'`
- Use native Zsh parameter expansion modifiers (`:t` for tail/basename, `:r` for remove extension) to generate arrays without subshell forks to `ls`, `xargs`, or `sed`. Example: `keys=(${$(ls dummy_keys/*.key 2>/dev/null):t:r})`

## What to Avoid

- Do not use 15+ line `case` statements for file extraction when `tar -xf` automatically handles standard compression formats.
- Avoid spinning up external processes to format simple lists when native Zsh parameter expansion can achieve the same result instantly.

## Constraints

- Zsh parameter modifiers (`:t:r`) only work when Zsh is the execution environment. Avoid using them in strictly POSIX `sh` or `bash` scripts.

## Origin

Synthesized from spikes: 026
Source files available in: sources/026-simplify-bash-wrappers/
