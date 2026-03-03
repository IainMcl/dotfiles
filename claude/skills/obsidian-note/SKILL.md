---
name: obsidian-note
description: Create a new note in the Obsidian vault. Use when asked to create a note, write something down, or save information to Obsidian.
---

# Create Obsidian Note

## Vault location

Notes live in `$VAULTS_PATH` (currently `/home/iainmclaughlan/notes/hitchhiker/`).
New notes go in the `inbox/` directory.

## File naming

Convert the note title to a filename by replacing spaces with underscores and
appending `.md`:

```
"My Great Note" → My_Great_Note.md
```

## Choose the right template

Read the templates in `$VAULTS_PATH/templates/` and pick the best match based
on what the user wants to write about:

| Template | When to use |
|---|---|
| `note.md` | General notes, default if nothing else fits |
| `daily.md` | Daily journal / reflection |
| `code_snip.md` | Code snippet for personal projects |
| `code_travelperk.md` | Code snippet related to TravelPerk work |
| `acronyms.md` | Definition of an acronym |
| `project_summary.md` | Summary of a project (outcomes, challenges, feedback) |
| `travelperk.md` | General TravelPerk work note |
| `walk_report.md` | Hill walking / munro report |

## Fill in the template

Replace all `{{placeholder}}` values in the chosen template:

- `{{title}}` — the note title
- `{{date}}` — today's date in `YYYY-MM-DD` format
- `{{language}}` — programming language (code templates)
- `{{description}}`, `{{meaning}}`, `{{notes}}` — generate from context

### Required frontmatter: `hub` and `aliases`

Every note **must** have `hub` and `aliases` set correctly in the YAML
frontmatter. These are how Obsidian organises and cross-links notes.

- **`hub`** — determines which section the note is sorted into. Each template
  has a default hub (e.g. `dailies`, `hills`, `travelperk`, `notes`). For code
  templates the hub is the programming language name.
- **`aliases`** — alternative names used for linking to the note with `[[...]]`.
  Always include at least the note title as an alias. For daily notes also add
  the human-readable date and ISO date string.

Example frontmatter:
```yaml
---
title: "My Great Note"
date: "2026-03-01"
aliases:
  - My Great Note
hub: notes
tags:
  - note
---
```

Fill in the body sections using the current conversation context. Write in the
user's voice — concise, factual, no fluff.

## Line width

Wrap prose and comments at **80 characters**. This can stretch to **120** when
needed for readability (e.g. long inline code, table rows). URLs and code
fences may exceed 120 — never break a URL across lines.

## Formatting style

Use proper markdown structure — headings, prose, lists, and tables — for
explanations. Only put actual code or commands inside fenced code blocks.
Do **not** use code-comment blocks as a substitute for markdown prose.

## Obsidian links

Wrap terms that likely have their own notes in the vault with `[[...]]`. Apply
this to:

- Other notes that are clearly related (e.g. `[[git]]`, `[[git reset]]`)
- Key concepts that are hub-level topics (e.g. `[[terraform]]`, `[[python]]`)
- Named tools, commands, or technologies central to the note's subject

Do **not** link every occurrence — link on first meaningful use in the body.
Do **not** link terms inside code fences.

## Create the file

Write the completed note to `$VAULTS_PATH/inbox/{filename}`.

Tell the user the full path so they can open it.
