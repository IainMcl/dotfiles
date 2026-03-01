---
name: research
description: Research a topic by exploring the codebase and external documentation. Use when asked to investigate how something works, find usage patterns, or look up library/API docs.
---

# Research

Investigate a question by combining codebase exploration with external
documentation lookups. Return a concise, structured answer — not a dump of
everything found.

## Clarify the question

Before diving in, make sure the research goal is specific. If the user's
question is vague, ask one clarifying question to narrow scope. Good research
has a clear deliverable: an answer, a recommendation, or a summary.

## Codebase exploration

### Trace from entry points

Start from known entry points (routes, CLI commands, main functions) and follow
the call chain. Don't grep randomly — work top-down.

### Find patterns and conventions

```bash
# Find all implementations of a pattern
grep -r "pattern" --include="*.py" -l
# Find where something is imported/used
grep -r "from module import" --include="*.py"
```

Use Glob for file discovery, Grep for content search, Read for full context.

### Map the relevant code

For each significant file, read it fully. Note:

- Key functions and their responsibilities
- Data flow between components
- Configuration and environment dependencies
- Error handling boundaries

## External documentation

### When to look externally

- The codebase uses a library/API and you need to understand its behaviour
- The user asks about best practices or recommended approaches
- Internal code references external concepts (protocols, standards, specs)

### How to search

Use `ref_search_documentation` for library/framework docs first — it's faster
and more targeted than general web search. Fall back to `WebSearch` for broader
topics or recent information.

Read the actual docs (`ref_read_url` or `WebFetch`) rather than summarising
from search snippets.

## Present findings

Structure the answer as:

1. **Summary** — one paragraph answering the question directly
2. **Key findings** — bullet points with file/line references for codebase
   findings, or doc links for external findings
3. **Recommendations** (if applicable) — concrete next steps or options with
   trade-offs

### Rules

- Cite specific files and line numbers for codebase claims: `path/to/file.py:42`
- Link to docs for external claims
- Flag uncertainty — say "I didn't find X" rather than guessing
- Keep it concise. If the user wants more detail on a specific finding, they'll
  ask
- Don't suggest code changes unless asked — this is research, not implementation
