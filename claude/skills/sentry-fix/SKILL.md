---
name: sentry-fix
description: Find the highest-frequency unresolved Sentry error for the VAT & Invoicing or Billing team, understand its root cause, create a Jira ticket in the APP project, implement a fix, and open a draft PR. Use when asked to "fix sentry issues", "triage sentry errors", "look at sentry", "what's broken in sentry", "create a fix for a sentry issue", or "sentry triage". Runs the full flow autonomously in the background.
---

# Sentry Fix

End-to-end flow: find the top Sentry error for the team → understand root cause → create Jira ticket → implement fix → open draft PR.

## Step 1 — Ask for the repo

Ask the user one question: **which repo should the fix go into?** (full GitHub path, e.g. `travelperk/billing-service`)

If the user has already specified this, skip the question.

## Step 2 — Spawn a background agent

Tell the user: "Running in the background — I'll let you know when the PR is ready."

Then spawn a background agent with the full instructions below. Pass through the repo name.

---

## Background agent instructions

### 2a — Fetch top Sentry issue

Use the Sentry MCP to list unresolved issues for the VAT & Invoicing / Billing team. Filter to:
- Teams: `VAT & Invoicing` or `Billing`
- Status: unresolved
- Sort: by event count (frequency), descending

Take the **single highest-frequency issue**.

Capture:
- Issue ID and title
- Event count and affected users
- First seen / last seen
- Sentry issue URL
- Full stack trace from the most recent event

### 2b — Understand the root cause

Read the stack trace carefully. Identify:
- The exact file and line where the error originates
- What condition or input triggers it
- Why it happens (missing null check, wrong assumption, race condition, etc.)
- Whether it's a regression or a long-standing issue (use first seen date)

Check out the relevant source files in the repo to confirm your reading of the bug. Don't guess — read the actual code before proposing a fix.

```bash
gh repo clone <repo> /tmp/sentry-fix-<issue-id> 2>/dev/null || true
```

### 2c — Create the Jira ticket

Use the Atlassian MCP (`createJiraIssue`) to create a bug ticket:

- **Project**: APP (https://travelperk.atlassian.net)
- **Issue type**: Bug
- **Summary**: `[Sentry] <concise description of the error>`
- **Description**:
  ```
  ## Sentry issue
  <sentry URL>
  Frequency: <event count> events, <affected users> users affected
  First seen: <date> | Last seen: <date>

  ## Root cause
  <your analysis — file, line, why it happens>

  ## Stack trace (excerpt)
  <most relevant frames>
  ```
- **Labels / component**: VAT & Invoicing or Billing (whichever applies)
- **Priority**: based on frequency — >1000 events = High, >100 = Medium, else Low

Note the ticket number (e.g. `APP-110486`) — you'll need it for the branch name and PR.

### 2d — Implement the fix

On a new branch named `APP-<ticket-number>-<short-description>` (e.g. `APP-110486-fix-null-invoice-id`):

1. Make the minimal fix that addresses the root cause
2. Don't refactor surrounding code — fix the specific bug
3. Add a comment explaining *why* the fix is needed if it's not obvious from the code

If you're not confident the fix is correct (e.g. the bug requires context you can't determine from the code alone), implement the most likely fix and flag the uncertainty in the PR description.

### 2e — Create the draft PR

```bash
gh pr create --draft \
  --title "fix: <description> (APP-<ticket-number>)" \
  --body "<body>"
```

PR body should include:
```
## What
<one sentence: what bug this fixes>

## Why
<root cause in plain English — what condition triggered the error>

## Sentry
<sentry URL> — <event count> events, <N> users affected

## Jira
https://travelperk.atlassian.net/browse/APP-<ticket-number>

## Fix
<brief explanation of the change and why it works>

## Risks
<anything uncertain, edge cases to watch, or areas where a reviewer should pay extra attention>
```

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true` — the sandbox breaks TLS verification for GitHub API calls.

### 2f — Report back

Reply to the user with:
- Sentry issue title and frequency
- Jira ticket link
- Draft PR link
- One-sentence summary of the fix
