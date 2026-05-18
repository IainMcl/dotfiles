---
name: incident-response
description: Run a full incident response workflow for an active incident. Covers investigation, blast radius via Snowflake, Slack channel triage, fix implementation, Jira ticket, draft PR, Notion debrief, and Datadog monitor review. Use when asked to "run incident response", "we have an incident", "investigate this error", or given a Sentry URL with urgency context.
---

# Incident Response

End-to-end incident response: gather context → investigate root cause → measure blast radius → implement fix → document everything.

## Slack update pattern

The incident Slack channel is the live feed of the investigation. Check it:
- **Once at the start** (Step 1) to get a full picture before touching anything
- **Before each subsequent step** to catch new findings from other investigators

At each re-check, only surface messages newer than the previous check. If a new finding is directly relevant to the current step (e.g. someone just identified the root cause while you're about to investigate), incorporate it and note that you did so.

Track a `last_checked` timestamp after each read and use it to filter the next fetch.

---

## Step 0 — Gather inputs

At least one of the following **entry points** must be provided. Ask for any that are missing:

| Input | Example | Notes |
|---|---|---|
| **Sentry issue URL** | `https://sentry.io/organizations/.../issues/123/` | Primary entry point |
| **Datadog monitor/alert URL** | `https://app.datadoghq.com/monitors/456` | Use if no Sentry issue exists yet |
| **Slack incident channel** | `#inc-2026-01-invoice-failures` | Use if alerted via Slack without a direct link |

At least one entry point is required — if none is provided, ask before proceeding.

Also ask for anything not already provided:

- **Repo** — full GitHub path (e.g. `travelperk/billing-service`)
- **Notion debrief page** — URL to update, or `"new"` to create one (can be skipped if not yet created)

**Entry point routing:**
- **Sentry URL given** → proceed from Step 2 (Sentry fetch)
- **Datadog URL given, no Sentry** → fetch the Datadog alert in Step 2 to find the affected service/error, then search Sentry for related issues before investigating
- **Slack channel only** → read the channel in Step 1 and extract any Sentry/Datadog links posted there; if none found, treat the channel messages as the primary error signal

Tell the user: "Running incident response — I'll confirm each step as I go."

---

## Step 1 — Read the Slack incident channel

Before touching the codebase, read the incident channel. Other investigators may have already found the root cause, affected customers, or a mitigation path.

Use the Slack MCP (`slack_read_channel`) to fetch recent messages from the incident channel.

Extract and summarise:
- Timeline of when the issue was first noticed
- Any root cause theories already posted
- Customer names or IDs mentioned as affected
- Any mitigations already applied or attempted
- Names of who is investigating what (avoid duplicating their work)

**Confirm to user**: "Read #channel — here's what the team has found so far: ..."

---

## Step 2 — Fetch the Sentry issue

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

Use the Sentry MCP to fetch the issue at the provided URL.

Capture:
- Issue title and ID
- Event count and affected users
- First seen / last seen timestamps
- Full stack trace from the most recent event
- Any linked releases or tags

**Confirm to user**: "Fetched Sentry issue: <title> — <N> events, <N> users, first seen <date>."

---

## Step 3 — Investigate root cause

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

Read the stack trace. Identify the exact file, line, and condition triggering the error.

Clone or navigate to the repo and read the relevant source files. Do not guess — confirm the bug in the code before proposing a fix.

```bash
gh repo clone <repo> /tmp/incident-<issue-id> 2>/dev/null || git -C /tmp/incident-<issue-id> pull
```

Cross-reference with Slack findings from Step 1. If a team member already identified the root cause, validate it in the code rather than starting from scratch.

**Confirm to user**: "Root cause identified: <file>:<line> — <one sentence explanation>."

---

## Step 4 — Measure blast radius via Snowflake

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

Query Snowflake to determine how many records and customers are affected.

Tailor the query to the root cause — e.g. if the bug corrupts invoices created after a certain date, query for invoices in that state.

Save both the query and results. Include:
- Number of affected records
- Number of affected customers / organisations
- Date range of impact
- Whether impact is ongoing or bounded

If Snowflake MCP is unavailable, tell the user: "Snowflake not connected — please run this query manually: `<query>`" and continue.

**Confirm to user**: "Blast radius: <N> records, <N> customers affected since <date>."

---

## Step 5 — Check Datadog

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

Search Datadog for monitors or dashboards related to the affected service.

Look for:
- Any monitors that should have fired but didn't (detection gap)
- Any monitors that need threshold updates based on what you now know
- Error rate or latency spikes correlated with the incident timeline

If Datadog MCP is unavailable, note which service/metric to check manually and continue.

**Confirm to user**: "Datadog checked — <summary of monitor state / any gaps identified>."

---

## Step 6 — Create the Jira ticket

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

Use the Atlassian MCP (`createJiraIssue`) to create a bug ticket:

- **Project**: APP
- **Issue type**: Bug
- **Priority**: >1000 events = High, >100 = Medium, else Low
- **Summary**: `[Incident] <concise description>`
- **Description**:
  ```
  ## Sentry issue
  <sentry URL>
  Frequency: <event count> events, <N> users affected
  First seen: <date> | Last seen: <date>

  ## Root cause
  <file>:<line> — <explanation>

  ## Blast radius
  <N> records, <N> customers affected
  <Snowflake query used>

  ## Slack incident channel
  <link to channel>

  ## Stack trace (excerpt)
  <most relevant frames>
  ```

Note the ticket number for the branch name and PR.

**Confirm to user**: "Jira ticket created: APP-<N> — <link>."

---

## Step 7 — Implement the fix

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

On a new branch `APP-<ticket>-<short-description>`:

1. Make the minimal fix — do not refactor surrounding code
2. Follow existing service abstractions and patterns (check similar files first)
3. Add a *why* comment only if the fix is non-obvious
4. Run tests if the environment supports it

If uncertain about the fix, implement the most likely approach and flag uncertainty in the PR.

**Confirm to user**: "Fix implemented on branch <branch-name>."

---

## Step 8 — Create the draft PR

> **Slack check**: fetch messages newer than `last_checked`. Surface any new findings before proceeding.

```bash
gh pr create --draft \
  --title "fix: <description> (APP-<ticket>)" \
  --body "<body>"
```

PR body:
```
## What
<one sentence: what bug this fixes>

## Why
<root cause in plain English>

## Blast radius
<N> records, <N> customers affected since <date>

## Sentry
<sentry URL> — <N> events, <N> users

## Jira
https://travelperk.atlassian.net/browse/APP-<ticket>

## Fix
<what changed and why it works>

## Risks
<anything uncertain, edge cases, areas for reviewer attention>
```

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true`.

**Confirm to user**: "Draft PR opened: <link>."

---

## Step 9 — Update the Notion incident debrief

> **Slack check**: fetch messages newer than `last_checked`. Incorporate any final timeline details or follow-up actions posted by the team into the debrief.

Use the Notion MCP to update the debrief page at the provided URL (or create one if "new" was specified).

Include:
- **Timeline**: when the issue started, when it was detected, when the fix was deployed
- **Root cause**: plain-language explanation
- **Affected data**: blast radius figures from Snowflake
- **Remediation**: what the fix does, PR link, Jira link
- **Detection gap**: did monitors catch this? If not, what should be added?
- **Follow-up actions**: anything that needs to happen post-fix (data backfill, monitor updates, etc.)

Write in blameless, conversational language. Do not make claims not supported by evidence from the codebase, Sentry, or Slack.

If Notion MCP is unavailable, output the debrief content as markdown so the user can paste it manually.

**Confirm to user**: "Notion debrief updated: <link>."

---

## Final summary

Once all steps are complete, output:

```
## Incident response complete

- Root cause: <one sentence>
- Blast radius: <N> records, <N> customers
- Jira: APP-<N> — <link>
- PR: <link>
- Notion debrief: <link>

Remaining actions:
- <any manual steps needed (e.g. Snowflake query to run, monitor to update)>
```
