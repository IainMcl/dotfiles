---
name: personal-documenter
description: Track achievements, projects, and impact for performance reviews and brag docs. Use when recording completed work, preparing for performance reviews, or capturing achievements.
---

# Personal Documenter

Records work achievements and projects into the Obsidian vault for performance reviews and brag documents.

## Vault structure

- **Project summaries**: template at `/home/iainmclaughlan/notes/hitchhiker/templates/project_summary.md`, save to `/home/iainmclaughlan/notes/hitchhiker/notes/work_projects/YYYY-MM-DD_<project-name>.md`
- **Performance documents**: template at `/home/iainmclaughlan/notes/hitchhiker/templates/performance_document.md`

## Frontmatter rules

DataView queries use frontmatter to cross-reference documents automatically — do not manually add links between files.

### project_summary.md frontmatter
- `title`: project name
- `date`: date completed or documented
- `hub`: always `"[[projects]]"`
- `skills`: comma-separated list of skills demonstrated
- `performance`: link to the relevant performance document e.g. `"[[Performance Document 2026]]"`
- `status`: one of `in-progress`, `completed`, `abandoned`
- `tags`: relevant tags

### performance_document.md frontmatter
- `title`: e.g. `"Performance Document 2026"`
- `created`: creation date
- `year`: the review year e.g. `"2026"`
- `current_level`: current job level
- `review_period`: e.g. `"Jan 2026 – Dec 2026"`
- `calibration_date`: date of calibration meeting if known

## Writing style

- First person, honest, and reflective.
- Focus on impact, not just activity. For every achievement capture:
  - **What** — the problem solved, its complexity and strategic importance
  - **How** — your approach, decisions made, leadership demonstrated
  - **Impact** — results with metrics where possible (short-term and long-term)
  - **Performance demonstrated** — how this shows performance at or beyond your level
- Quantify wherever possible — numbers, percentages, adoption, time saved.
- Be specific — vague entries are not useful in calibration discussions.

## Creating a project summary

1. Ask for: project name, date, skills used, status, and which performance year it belongs to.
2. Read the template and populate all fields.
3. Save to `notes/work_projects/YYYY-MM-DD_<project-name>.md`.
4. Ensure `performance` frontmatter links to the correct performance document.

## Creating or updating a performance document

1. Check if one already exists for the year before creating a new one.
2. Use the template for new documents, populating all frontmatter fields.
3. When updating, add or enrich entries — do not overwrite existing content without confirming.

## Constraints

- Never overwrite existing content without confirming with the user.
- Do not invent metrics or impact — only document what the user provides or confirms.
- If details are vague, ask for specifics before writing.
