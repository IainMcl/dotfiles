---
name: commit-code
description: Instructions for committing code changes. Use when committing code, creating commits, or pushing changes upstream.
---

# Committing Code Changes

## Before Committing

1. **Verify you're on a feature branch** - never commit directly to main
2. **Run relevant tests** - be smart about which tests to run based on the changes made, don't run the entire test suite for unrelated changes

## Pre-commit Hooks

Pre-commit hooks will run and may modify files. If hooks modify files:
1. Stage the modified files
2. Commit again

## Commit Message Format

```
<Title>

<Description>
```

### Rules

**Title (first line):**
- Keep it brief and descriptive
- Do NOT use semantic commit prefixes (no `feat:`, `fix:`, `chore:`, etc.)

**Description:**
- **1-2 sentences maximum** - keep it high-level
- Focus on **why** the change was made, not a granular list of what changed
- The diff already shows the details - don't repeat them in prose
- Do NOT write:
  - Bullet lists of every file or function changed
  - Vague fluff like "make more resilient", "make more scalable", "handles gracefully"
  - Line-by-line summaries of the code changes

**DO NOT Include:**
- No "Co-Authored-By" lines
- No "Generated with Claude Code" or similar attribution
- No emojis
- Keep the commit message clean and professional

## Pushing Changes

When changes have been committed ask if we are ready to push. If we are ready to push, push using:

```bash
just push
```

If pushing as part of a rebase use

```bash
git push --force-with-lease
```

- **Only push upstream when explicitly asked**
- The upstream remote is `origin`
- **Never force push** - the only exception is when rebasing the branch



