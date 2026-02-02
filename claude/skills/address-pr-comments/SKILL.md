---
name: address-pr-comments
description: Fetch relevant comments from a GitHub PR. Use when asked to get PR comments, review feedback, or check what reviewers said.
---

# Fetching PR Comments

Use GitHub CLI (`gh`) to fetch PR comments.

## Ignore These

**Bots to ignore completely:**
- `tk-elbot-2-0`
- `atlantis-bot`
- `github-copilot` / `copilot`

**Resolved conversations:**
- Explicitly marked as resolved
- Contextually no longer relevant (e.g., addressed in subsequent commits)

**Exception - unblocked-bot:**
- Include only if a human has responded to validate the finding

## Include These

- Unresolved human comments
- Review comments (approvals, rejections, change requests)
- Validated unblocked-bot findings

## Responding to Addressed Comments

After addressing a PR comment, reply to the comment thread to confirm it's been handled:

```
gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -f body="<brief description of fix>

— AI agent"
```

- Keep the response brief and factual
- Sign off with "— AI agent" to indicate it was addressed by the AI
