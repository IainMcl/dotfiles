---
name: notion
description: Read, search, or write Notion pages. Use when asked to find, read, search, create, or update a Notion page.
---

# Notion

Use the Notion MCP to search and fetch pages. Follow the efficiency rules below to minimise token usage.

## Efficiency rules

### 1. Try Obsidian first
Check `/home/iainmclaughlan/notes/hitchhiker/` for a local note before touching the MCP. Direct `Read`/`Grep` is cheaper than any MCP call.

### 2. Search highlights are often enough
`notion-search` returns `highlight` snippets in results. If the snippet answers the question, stop — do not fetch the full page.

### 3. Grep the output file, don't read sequentially
When a `notion-fetch` result is saved to a file (it will tell you the path), use `Grep` to find the relevant section rather than reading the file in chunks:
```
Grep "destructive migration" <output_file_path>
```

### 4. Only fetch when you need more than the snippet
If the search highlight is insufficient, fetch the page — but immediately `Grep` the output file for the specific section needed rather than reading it all.

### 5. Save useful pages to Obsidian after first fetch
If a page is likely to be referenced again, save a condensed version to Obsidian so future lookups are free:
```
/home/iainmclaughlan/notes/hitchhiker/<topic>.md
```

## Workflow

1. Check Obsidian first
2. Run `notion-search` with a focused query
3. If the highlight answers the question → done
4. If not → `notion-fetch` the page, then `Grep` the output file for the specific content
5. Summarise the relevant section only
6. Offer to save a condensed version to Obsidian if it's a reference page

---

## Writing to Notion

### Mermaid diagrams

- **`\n` does not work as a line break inside node labels.** Notion's Mermaid renderer ignores it and renders it literally. Use a space or ` - ` to separate text within a label instead.
- Keep node labels short - long labels without breaks will overflow. Use ` - ` as a readable separator when you need to pack multiple pieces of information into one node.

### General writing tips

- Don't include the page title at the top of the content — Notion renders the `title` property as the heading automatically.
- Use `---` for section dividers between major sections in longer documents.
- Fetch the page with `notion-fetch` before using `update_content` — the `old_str` must match the current content exactly.
