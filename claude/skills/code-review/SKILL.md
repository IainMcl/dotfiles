---
name: code-review
description: Review code for bugs, style, and design issues. Use when asked to review a PR, review local changes, or do a code review.
---

# Code Review

Review code changes and provide actionable feedback on bugs, design, clarity,
and style. Supports two modes: GitHub PR review and local diff review.

## Determine the review target

- If given a PR number or URL, use **PR review mode**.
- If no PR is specified, use **local diff review mode** (staged + unstaged changes).

---

## PR Review Mode

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true` — the sandbox breaks TLS verification for GitHub API calls. Always set this flag for every `gh` invocation.

### Fetch the diff

```bash
gh pr diff {PR_NUMBER}
```

Get PR context (description, linked issues):

```bash
gh pr view {PR_NUMBER} --json title,body,labels,baseRefName,headRefName
```

### Read changed files in full

Don't review the diff in isolation. For each significantly changed file, read
the full file to understand the surrounding context before commenting.

### Leave review comments

For issues found, leave inline comments on the PR:

```bash
gh api repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/reviews \
  -f event="COMMENT" \
  -f body="Overall review summary" \
  --jsonArray comments='[{"path":"file.py","line":42,"body":"Issue description"}]'
```

For minor or nitpick items, prefix the comment body with `nit:`.

Sign off every comment with `-Claude`.

---

## Local Diff Review Mode

### Gather the diff

```bash
git diff
git diff --staged
```

If both are empty, check for unpushed commits against the base branch:

```bash
git log --oneline origin/main..HEAD
git diff origin/main..HEAD
```

### Read changed files in full

Same as PR mode — read surrounding context before commenting.

### Present findings

Print findings grouped by file. For each issue, include:

- **File and line** — `path/to/file.py:42`
- **Severity** — bug, design, clarity, style, nit
- **Description** — what's wrong and a suggested fix

---

## What to look for

Focus on issues that matter. In priority order:

1. **Bugs** — logic errors, off-by-ones, null/None handling, race conditions
2. **Security** — injection, auth gaps, secrets in code, OWASP top 10
3. **Design** — wrong abstraction, tight coupling, violation of existing patterns
4. **Edge cases** — missing error handling at system boundaries, unhandled states
5. **Clarity** — misleading names, unnecessary complexity, missing *why* comments
6. **Style** — only flag if inconsistent with the surrounding codebase

## What to skip

- Don't flag formatting issues handled by linters/formatters.
- Don't suggest adding docstrings, type hints, or comments to unchanged code.
- Don't suggest renaming things that follow the project's existing conventions.
- Don't request tests unless the change is clearly untested and risky.
- Don't repeat what the diff already makes obvious.

## Tone

Be direct and constructive. State the issue, explain why it matters, suggest a
fix. No filler, no praise sandwiches.
