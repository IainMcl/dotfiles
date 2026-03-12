---
name: project-update
description: Generate a concise project status update for product managers, formatted for Slack. Use this skill when asked to write a project update, status report, sprint summary, progress briefing, or team update for PMs or stakeholders. Trigger on phrases like "write a project update", "create a status update for slack", "summarise what happened this week", "what should I tell the PM", "prepare an update for the team", "weekly update", "project status", even if the user doesn't explicitly mention Slack or PMs.
---

# Project Update

Generate a short, punchy project status update for a PM or stakeholder audience, formatted for Slack.

## Step 0 — Check for project config

Before asking anything, look for `.claude/project-update.json` in the current working directory:

```bash
cat .claude/project-update.json 2>/dev/null
```

**If the config exists:** load it. You already know the project name, sources, channel, audience, and any standing highlights/exclusions. Skip to Step 1 and only ask for the time period (e.g. "What period should this cover? e.g. this week, last sprint").

**If no config exists:** continue to Step 1 and ask the full set of questions.

## Step 1 — Gather context upfront

Ask these questions in a single message (don't ask one at a time):

1. **Project name** — what's the project called?
2. **Audience & channel** — who's reading this, and which Slack channel (if known)?
3. **Time period** — what window should the update cover? (e.g. "this week", "last sprint", "since last Friday")
4. **Sources** — which of these are relevant for this project? (tick all that apply)
   - Git repo (recent commits / merged PRs)
   - Slack (recent messages in a project channel)
   - Jira (tickets completed / in progress / blocked)
   - Notion (project page / docs)
   - Local `docs/` folder (changelogs, screenshots, notes)
5. **Anything to highlight or exclude?** — wins to call out, sensitive topics to skip

If the user provides most of this upfront, skip the questions you already have answers to.

## Step 2 — Gather data from sources

Pull from the relevant sources in parallel. Gather facts, not prose — you'll write the update yourself.

### Git
```bash
# Recent merged PRs and commits
git log --oneline --since="7 days ago" --merges
git log --oneline --since="7 days ago" --no-merges | head -20
```
Look for: features shipped, fixes, notable changes.

### Slack
Use `slack_read_channel` with the project channel name and the relevant date range.
Look for: decisions made, blockers raised, things unblocked, announcements.

### Jira
Use `searchJiraIssuesUsingJql` with a query like:
```
project = PROJ AND updated >= -7d ORDER BY updated DESC
```
Look for: tickets moved to Done, tickets blocked, tickets newly created this period.

### Notion
Use `notion-search` for the project name, or `notion-fetch` if the user provides a URL.
Look for: goals, milestones, decisions, current status notes.

### docs/ folder
```bash
ls -lt docs/ | head -20
```
Look for: recent screenshots (`.png`, `.jpg`, `.gif`), changelogs, status notes. Note any image files that are recent and visually relevant.

## Step 3 — Synthesise and write the update

Write the update for a busy PM who will read it in 30 seconds. Lead with outcomes, not activities. Use plain language — no jargon, no internal ticket IDs unless they add context.

### Format

Use Slack markdown (*bold*, not `##` headers). Keep it tight — aim for under 200 words in the body.

```
*[Project Name] — [Period]*

✅ *Done*
• [concrete outcome, not task description]
• [concrete outcome]

🔄 *In Progress*
• [what's actively being worked on]

🚧 *Blockers* (omit section if none)
• [specific blocker and who owns it]

👀 *Up Next*
• [what's coming in the next period]
```

**Writing rules:**
- Lead with outcomes ("Shipped X", "Fixed Y", "Launched Z") not activities ("Working on X", "Started Y")
- If a Jira ticket or PR is worth linking, include it inline as a bare URL — Slack unfurls them
- One bullet per item — no sub-bullets
- Omit sections that have nothing meaningful to say (e.g. no blockers → skip 🚧)

## Step 4 — Include images if relevant

If you found recent screenshots or images in `docs/` (or attached to PRs), check if they're worth including — e.g. a UI screenshot showing a new feature, or a chart showing a metric.

If so, note them below the update text:
```
📸 *Screenshot:* [brief description]
[paste the image or note the file path for the user to attach]
```

Don't force images in — only include them if they genuinely add signal for the PM.

## Step 5 — Deliver

Present the formatted update and ask:
- "Does this look right, or anything to tweak?"
- "Want me to send this to [channel] via Slack?"

If the user confirms, use `slack_send_message` to post it. Otherwise provide the text for copy-paste.
