---
name: weekly-review
description: Run a weekly achievement review - pulls from Jira, GitHub, and Slack to capture what you shipped in the last week, maps achievements to your 2026 goals, and appends impact-focused entries to your brag doc. Use when asked to "do a weekly review", "capture this week's wins", "update my brag doc", "what did I ship this week", "record my achievements", "what have I done this week", "add to my performance doc", or anything about tracking weekly progress, brag doc entries, or performance evidence. Trigger even if the user just says "weekly review" or "document what I did".
---

# Weekly Review

Collects what you shipped in a given period, frames it in terms of impact and performance evidence, cross-references your 2026 goals, and appends approved entries to your brag doc.

## Step 0 - Check config

Look for a config file:

```bash
cat .claude/weekly-review.json 2>/dev/null || cat ~/.claude/weekly-review.json 2>/dev/null
```

Config schema:
```json
{
  "jira_project": "APP",
  "jira_account_id": "712020:77f9549c-8046-404d-b4f2-84f41769f772",
  "github_repos": ["org/repo"],
  "slack_channels": ["channel-name"],
  "vault_path": "/Users/iain.mclaughlan/notes/hitchhiker",
  "brag_doc": "performance/2026/2026_01_15_Perk_performance.md",
  "goals_file": "performance/2026/2026 Professional Goals.md"
}
```

If no config exists, use these defaults:
- Jira project: `APP`, account ID: `712020:77f9549c-8046-404d-b4f2-84f41769f772`
- Vault: `/Users/iain.mclaughlan/notes/hitchhiker/`
- Brag doc: `performance/2026/2026_01_15_Perk_performance.md`
- Goals: `performance/2026/2026 Professional Goals.md`
- Ask about GitHub repos and Slack channels if not in config.

## Step 1 - Confirm scope

Ask one question only: "What period should this cover? (default: last 7 days)"

Map casual answers ("this week", "last week") to a concrete date range before querying.

## Step 2 - Gather data in parallel

Pull from all sources simultaneously - gather raw facts, not prose.

### Jira
Search for tickets assigned to you that were updated in the period:
```
project = APP AND assignee = "712020:77f9549c-8046-404d-b4f2-84f41769f772" AND updated >= -7d ORDER BY updated DESC
```
Note tickets that: moved to Done/Released, moved to Review/Testing, had significant progress, or were newly created.

### GitHub
For each configured repo, check recent activity:
- PRs merged by you
- PRs you reviewed with substantive comments
- Use `gh pr list --author @me --state merged` if in the repo, or ask the user which repos to check

### Slack
If channels are configured, use `slack_read_channel` for each over the period.
Look for: decisions made, things shipped or announced, blockers raised or resolved, cross-team coordination you drove.

### Notion
Search for pages created or updated by you in the period:
```
query: "design doc documentation"
filters: created_by_user_ids: ["6c63f2e7-847a-4fe3-828d-561324892f50"], created_date_range: { start_date: <period start> }
```
Look for: design docs, technical references, incident write-ups, brainstorm docs, meeting notes. Fetch any that look significant to understand their content before including them.

### Goals and brag doc
Read both files from the vault in parallel:
- Goals: to understand the 4 goals and how achievements map to them
- Brag doc: to understand the existing format and avoid duplicating entries already captured

## Step 3 - Synthesise achievements

For each meaningful piece of work, draft an entry using the personal-documenter writing style:

- First person, honest, specific
- Lead with impact not activity - "Shipped X that Y" not "Worked on X"
- For each entry capture:
  - **What** - the problem solved, its complexity and strategic importance
  - **How** - your approach, decisions made, leadership demonstrated
  - **Impact** - results with metrics where possible (even estimated impact is useful)
  - **Goal mapping** - which 2026 goal this maps to, and why

Don't invent metrics. If impact isn't clear from the data, note what you can confirm and flag where the user should add more detail.

**Worth capturing:**
- Ticket shipped to production or released
- PR merged (especially cross-team, complex, or high-impact)
- Design doc or proposal written
- Cross-team coordination or unblocking
- Positive feedback or recognition received
- Anything that maps to a 2026 goal

**Skip:**
- In-progress tickets with no state change
- Routine chores (dependency bumps, minor config)
- Things that will be better captured when they actually ship

## Step 4 - Present draft for review

Show proposed entries before writing anything:

```
## Proposed entries for [period]

**1. [Short title]**
Maps to: [Goal name]
> [2-4 sentence entry written in first person, impact-focused]

**2. [Short title]**
Maps to: [Goal name]
> ...
```

Then ask:
- "Does this look right? Any to remove, edit, or add detail to?"
- "Any wins I missed that aren't in Jira/GitHub/Slack?"

Wait for approval before writing to any file.

## Step 5 - Write to brag doc

Once the user approves (they can approve all, drop some, or request edits):

1. Read the current brag doc
2. Find the right place to append - match the existing structure (usually a week heading or date section)
3. Append the approved entries in the same format as existing entries
4. Never overwrite or restructure existing content

After appending, ask: "Any of these are significant enough to deserve a full project summary note?" If yes, follow the personal-documenter workflow to create one at `notes/project_summaries/`.

## Constraints

- Never write to the brag doc without the user explicitly approving the draft
- Never invent metrics or impact - only document what the data supports or the user confirms
- If a ticket or PR is ambiguous, describe what you can confirm and ask rather than guess
- Keep the brag doc's existing formatting and structure intact
