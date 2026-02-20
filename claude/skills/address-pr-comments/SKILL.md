---
name: address-pr-comments
description: Fetch and respond to GitHub PR comments. Use when asked to get PR feedback, address reviewer comments, or check what reviewers said.
---

# Addressing PR Comments

## Setup

Define your target PRs as variables:

```bash
OWNER="travelperk"
REPO="terraform-aws"
PR_NUMBERS=(15374 15375 15376 15377 15378 15379)  # Or pass as argument

Step 1: Fetch Comments from a PR

# Get all comments (including review comments on code)
gh api repos/$OWNER/$REPO/pulls/{PR_NUMBER}/comments \
  --template='{{range .}}{{printf "ID: %d | Author: %s | Resolved: %v\n" .id .user.login .resolved}}{{printf "Line %d:
%s\n\n" .line .body}}{{end}}'

# Get review summaries (approvals, rejections, change requests)
gh pr view {PR_NUMBER} --json reviews \
  --template='{{range .reviews}}{{printf "%s - %s\n" .author.login .state}}{{end}}'

Step 2: Filter Comments (apply these rules)

Skip entirely:
- Authors: tk-elbot-2-0, atlantis-bot, github-copilot
- Marked as .resolved: true
- Contextually addressed in later commits

Include for response:
- Unresolved comments from humans (.resolved: false)
- Review state: COMMENTED or CHANGES_REQUESTED
- unblocked-bot findings with human validation

Step 3: Reply to a Comment

# Get the comment ID from Step 1, then reply:
COMMENT_ID=2833726406
gh api repos/$OWNER/$REPO/pulls/comments/$COMMENT_ID/replies \
  -f body="Brief explanation of how this was addressed or why it's not needed.

— AI agent"

# Verify the reply was posted:
gh api repos/$OWNER/$REPO/pulls/comments/$COMMENT_ID \
  --template='{{.body}}'

Batch Processing Multiple PRs

# Check all PRs for unresolved human comments
for pr in "${PR_NUMBERS[@]}"; do
  echo "=== PR $pr ==="

  # Fetch and display comments
  gh api repos/$OWNER/$REPO/pulls/$pr/comments \
    --template='{{range .}}{{if and (ne .user.login "tk-elbot-2-0") (not .resolved)}}Comment {{.id}} by {{.user.login}}:
 {{.body}}{{"\n"}}{{end}}{{end}}'
done

Response Template

When replying to addressed comments:

<Concise explanation of the fix or clarification>

Example:
The [0] indexing is required because the new modules have count = var.create_new_invoice_collection_lambdas ? 1 : 0
applied to them. In Terraform, when count is used, resources must be referenced with [0] indexing to access the first
instance.

— AI agent

Troubleshooting

"Comment not found" error:
- Verify comment ID is correct: gh api repos/$OWNER/$REPO/pulls/comments/$ID
- Check PR number matches the comment's PR

Can't fetch comments:
- Ensure you have GitHub CLI installed: gh --version
- Check authentication: gh auth status
- Verify API access: gh api repos/$OWNER/$REPO

jq issues with filtering:
- Use --template instead of piping to jq (avoids escaping issues)
- Or use simple grep for basic filtering if template fails

Common Patterns

Get comments by a specific person:
gh api repos/$OWNER/$REPO/pulls/{PR}/comments \
  --template='{{range .}}{{if eq .user.login "username"}}ID: {{.id}} | {{.body}}{{"\n"}}{{end}}{{end}}'

Verify all replies were posted:
gh api repos/$OWNER/$REPO/pulls/{PR}/comments \
  --template='{{range .}}{{if contains .body "AI agent"}}✓ {{.id}}{{"\n"}}{{end}}{{end}}'
