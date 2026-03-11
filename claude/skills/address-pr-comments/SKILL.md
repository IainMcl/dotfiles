---
name: address-pr-comments
description: Fetch and respond to GitHub PR comments. Use when asked to get PR feedback, address reviewer comments, or check what reviewers said.
---

# Addressing PR Comments

## Fetching Comments

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true` — the sandbox breaks TLS verification for GitHub API calls. Always set this flag for every `gh` invocation.

### Get review comments (inline code comments)

```bash
gh api repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/comments
```

### Get review summaries (approvals, rejections, change requests)

```bash
gh pr view {PR_NUMBER} --repo {OWNER}/{REPO} --json reviews,comments
```

## Filtering Comments

Skip:
- Bot authors (copilot-pull-request-reviewer, github-actions, etc.)
- Comments marked as resolved
- Comments already addressed in later commits

Include:
- Unresolved comments from humans
- Review state: COMMENTED or CHANGES_REQUESTED

## Replying to Comments

**IMPORTANT**: The reply API requires the PR number in the path:

```bash
gh api repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/comments/{COMMENT_ID}/replies \
  -f body="Explanation of how this was addressed."
```

The comment ID comes from the `id` field in the comments response.

Sign off replies with `-Claude`.

## Response Style

Keep replies concise. Briefly explain what was changed or why the suggestion
wasn't needed. Don't repeat the reviewer's comment back to them.
