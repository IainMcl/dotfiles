---
name: review-pr
description: Read a GitHub PR and walk through review suggestions interactively. Use when asked to review a PR link, understand PR changes, or prepare review comments.
---

# Review PR

Read a GitHub PR, gather existing reviewer comments, analyse the diff, and walk
the user through suggestions interactively. **Never post comments on the PR.**

## 1. Fetch PR context

Extract owner, repo, and PR number from the provided link.

> **Note:** `gh` commands that hit GitHub's API require `dangerouslyDisableSandbox: true` due to TLS certificate verification in the sandbox. Always set this flag when running `gh` commands.

```bash
gh pr view {PR_NUMBER} --repo {OWNER}/{REPO} --json title,body,baseRefName,headRefName,labels
gh pr diff {PR_NUMBER} --repo {OWNER}/{REPO}
```

## 2. Fetch existing review comments

```bash
gh api repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/comments --jq '[.[] | select(.user.login | test("bot"; "i") | not) | {user: .user.login, path: .path, line: .line, body: .body}]'
gh pr view {PR_NUMBER} --repo {OWNER}/{REPO} --json reviews,comments
```

Skip bot comments. For each human comment, note:
- Who said it
- What file/line it's on
- Whether it's resolved or open

## 3. Read changed files in full

For every file with non-trivial changes, read the full file to understand
surrounding context. Don't review the diff in isolation.

## 4. Analyse

Look for:

1. **Bugs** — logic errors, off-by-ones, null/None handling, race conditions
2. **Security** — injection, auth gaps, secrets in code
3. **Design** — wrong abstraction, tight coupling, violation of existing patterns
4. **Edge cases** — missing error handling at system boundaries
5. **Clarity** — misleading names, unnecessary complexity

For each existing reviewer comment, understand their reasoning and note whether
the author has addressed it.

## 5. Present summary

Print a brief summary:

- What the PR does (1-2 sentences)
- Number of suggestions you have
- Summary of existing reviewer comments and their status (open/resolved/addressed)

## 6. Walk through suggestions

Step through each suggestion **one at a time**. For each, print:

- **File and line** — `path/to/file.py:42`
- **Severity** — bug, security, design, edge-case, clarity
- **The issue** — what's wrong and why it matters
- **Suggested fix** — concrete recommendation
- **Existing reviewer context** — if a reviewer already flagged this area,
  summarise their comment and whether it overlaps

After presenting each suggestion, **pause and wait** for the user. They may:
- Ask questions about the suggestion
- Disagree and want to skip it
- Ask you to draft a comment (but don't post it)
- Say "next" to move on

Only proceed to the next suggestion when the user is ready.

## Rules

- **Never comment on the PR** — all output stays in this conversation
- **Never approve or request changes on the PR**
- Read full files, not just the diff
- Be direct — state the issue, explain why, suggest a fix
- If a reviewer already made the same point, say so and don't repeat it
- When all suggestions are covered, offer to draft all agreed comments as a
  batch the user can copy-paste or post themselves
