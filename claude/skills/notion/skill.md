---
name: notion
description: Look up information in Notion. Use when asked to find, read, or search a Notion page.
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
