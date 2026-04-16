---
name: markdown-coding
description: Markdown coding conventions and style guide. Use when writing or modifying Markdown files.
---

# Markdown Coding

## Line Width

**All lines must be 80 characters or fewer.** This is the most important rule.

- Wrap prose at 80 characters — do not let paragraphs run on as a single long
  line.
- Break long URLs onto their own line. If a URL itself exceeds 80 chars, place
  it on its own line and accept the exception — do not break the URL itself.
- Code blocks are exempt from the 80-char limit when breaking would harm
  readability (e.g. long commands or paths), but keep them short where
  possible.

## Headings

- Use ATX-style headings (`#`, `##`, `###`), not underline-style (`===`/`---`).
- Leave one blank line before and after every heading.
- Use sentence case for headings, not title case.
- Do not skip heading levels (e.g. don't jump from `##` to `####`).

## Lists

- Use `-` for unordered list items, not `*` or `+`.
- Use `1.` for all items in ordered lists (let renderers handle numbering).
- Indent nested list items by 2 spaces.
- Leave a blank line before and after a list when it is adjacent to prose.

## Emphasis

- Use `**bold**` for strong emphasis.
- Use `_italics_` for light emphasis (underscores, not asterisks).
- Avoid combining bold and italic except when truly necessary.

## Code

- Use backtick code spans for inline code, command names, file paths, and
  identifiers: e.g. `npm install`, `~/.zshrc`.
- Use fenced code blocks (triple backticks) for multi-line code snippets.
  Always specify a language hint:
  ````
  ```bash
  echo "hello"
  ```
  ````
- Indent the contents of code blocks consistently (2 or 4 spaces depending on
  the language).

## Links

- Prefer reference-style links for long URLs to avoid breaking the 80-char
  limit:
  ```markdown
  See the [official docs][docs] for more detail.

  [docs]: https://example.com/very/long/path/to/documentation
  ```
- Use descriptive link text — never `click here` or bare URLs as link text.

## Blank lines & spacing

- Separate top-level sections with one blank line.
- Do not leave trailing whitespace at the end of lines.
- End every file with a single newline character.

## Tables

- Align column separators for readability in source, e.g.:
  ```markdown
  | Name  | Type   | Default |
  | ----- | ------ | ------- |
  | width | number | 80      |
  ```
- Keep table rows within 80 chars where possible; break into separate sections
  if they cannot fit.
