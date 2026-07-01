# Hybrid OfficeCLI+MarkItDown Workflow

## Requirements

- **Markitdown+OfficeCLI:** Must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.

## How to Build It

This approach merges the reliable DOM manipulation of `officecli` with the highly accurate text-rendering of `markitdown`.

### 1. Installation
Install both tools to be available globally:
```bash
# Install officecli (usually via standard setup script)
# Install markitdown with all extras for complex doc support
uv tool install "markitdown[all]"
```

### 2. Reading Documents
Always use `markitdown` for viewing content. It handles PPTX, DOCX, and XLSX perfectly.
```python
from markitdown import MarkItDown
md = MarkItDown()
result = md.convert('document.pptx')
print(result.text_content)
```

### 3. Modifying Documents
Use `officecli` for all writes. Both DOM addressing and text replacement work flawlessly and seamlessly persist across XML boundaries (like slides in PPTX).

**Via DOM Targeting:**
```bash
officecli set sample.docx /body/paragraph[1] --prop bold=true
```

**Via Text Replacement:**
```bash
officecli set sample.pptx / --find "old text" --replace "new text"
```

### 4. The Sync Loop (Critical)
After applying writes with `officecli`, you **MUST** flush to disk before reading with `markitdown`.
```bash
# 1. Edit
officecli set sample.docx / --find "A" --replace "B"
# 2. Flush
officecli close sample.docx
# 3. Read
uv run -q --with "markitdown[all]" python -c "from markitdown import MarkItDown; print(MarkItDown().convert('sample.docx').text_content)"
```

### 5. Multimodal (Images)
If the document has images, `markitdown` can perform OCR using any OpenAI-compatible API (OpenAI, Gemini, Ollama) by overriding the `base_url`:

```python
from markitdown import MarkItDown
from openai import OpenAI
import os

# Example: Pointing to a local/custom proxy
client = OpenAI(
    api_key=os.environ.get("GEMINI_API_KEY", "dummy"),
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/"
)
md = MarkItDown(llm_client=client, llm_model="gemini-2.0-flash")
result = md.convert('document_with_images.pptx')
```

## What to Avoid
- Do not use `markitdown` without the `[all]` or `[pptx]` extra if you expect to process PowerPoint files. It will throw a `MissingDependencyException`.
- Do not assume `markitdown` can see `officecli` edits immediately. `officecli` caches changes in a background daemon for speed. You must `officecli close` or `officecli save`.

## Constraints
- Performance is stellar: extracting 100-slide PPTX or 50-page DOCX takes ~150ms. It will not cause agent timeouts.
- DOM targeting syncs perfectly: Structural changes (like `bold=true`) made by `officecli` are fully parsed into Markdown formatting (`**text**`) by `markitdown`.

## Origin

Synthesized from spikes: 007, 008, 009, 010, 011, 012, 013, 014
Source files available in: 
- `sources/007-hybrid-targeting/`
- `sources/008-markitdown-baseline/`
- `sources/009-markitdown-multimodal/`
- `sources/010-chezmoi-officecli-setup/`
- `sources/011-pptx-hybrid-integration/`
- `sources/012-dom-targeting-sync/`
- `sources/013-markitdown-performance/`
- `sources/014-markitdown-images-local/`
