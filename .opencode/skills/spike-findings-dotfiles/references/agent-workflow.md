# Agent Workflow

## Requirements
- Concurrent writes to a single office document MUST be avoided to prevent zip corruption.
- Agents MUST utilize `officecli set <file> / --find <old> --replace <new>` instead of trying to compute DOM paths (`/slide[n]/shape[m]`) based on MarkItDown output.

## How to Build It
Agents processing text changes from MarkItDown outputs should feed those directly into global `officecli` text replacements. The officecli Resident Mode safely queues operations *if* they are submitted sequentially.

## What to Avoid
- Executing `officecli add` or `set` in parallel bash background jobs (`&`) against the same document. 
- Attempting to build AST parsers to reverse-map `<!-- Slide number: X -->` back to OpenXML elements.

## Constraints
- Without synchronization, `officecli` parallel writes corrupt the zip payload.

## Origin
Synthesized from spikes: 036, 037, 038
Source files available in: sources/036-full-skill-replacement-e2e/, sources/037-concurrent-officecli-resident-mode/, sources/038-markdown-to-dom-translation/
