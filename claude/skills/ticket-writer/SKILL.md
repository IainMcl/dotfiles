---
name: ticket-writer
description: Write and create Jira tickets using the Atlassian MCP. Use when creating task or bug tickets in the TK-APP project.
---

# Ticket Writer

Creates well-structured, actionable Jira tickets in the TK-APP project using the Atlassian MCP.

## Ticket types

### Task
Use for new work, features, or improvements.

```
## Description
<descriptive summary of what the aim is and why it matters>

## Acceptance Criteria
<brief description of what done looks like>
- [ ] <specific, testable criterion>
- [ ] <specific, testable criterion>

## Tech Note
<relevant implementation information — design docs, links to code, architectural decisions, dependencies>
```

### Bug
Use for defects and unexpected behaviour.

```
## Issue
<clear description of the problem — what is happening vs what should happen, steps to reproduce, environment if relevant>

## Acceptance Criteria
- [ ] <criterion>

## Tech Note
<relevant technical context — stack traces, related code, suspected cause>
```

## Jira defaults

- **Project**: `TK-APP (APP)`
- **Component**: `Vat & Invoicing` — component ID `11111`
- **Epic/Parent**: check for a relevant open epic before creating — search with `mcp__atlassian__searchJiraIssuesUsingJql` and link if appropriate

## Process

1. **Infer from context** — determine ticket type, title, description, and tech notes from the information provided. Only ask for what is genuinely missing.
2. **Always ask for priority** — do not infer priority. Ask the user: Highest / High / Medium / Low / Lowest.
3. **Check for a relevant epic** — search for open epics in TK-APP and ask the user if one applies.
4. **Draft the ticket** — show the full ticket draft to the user for review before creating.
5. **Create with MCP** — once approved, create using `mcp__atlassian__createJiraIssue`, then link the epic via `mcp__atlassian__editJiraIssue`.

## MCP approach (preferred)

Use `mcp__atlassian__createJiraIssue` with these parameters:
- `cloudId`: `785f3332-ecb2-49ff-9b5b-6e4829a689b2`
- `projectKey`: `APP`
- `issueTypeName`: `Task` (or `Bug`)
- `description`: Markdown string
- `additional_fields`: `{"components": [{"id": "11111"}]}`

**Important — component must use ID, not name.** Using `{"name": "Vat & Invoicing"}` causes acli and the MCP to attempt creating a new component, which fails due to permissions. Always use `{"id": "11111"}`.

**Important — epic link cannot be set on creation.** The `customfield_10014` field is not on the create screen. After creating the ticket, set the epic link via:
```
mcp__atlassian__editJiraIssue(issueIdOrKey=NEW-KEY, fields={"customfield_10008": "APP-XXXXX"})
```

## Constraints

- Always show the full draft to the user before creating the ticket.
- Do not create the ticket without user approval.
- Acceptance criteria must be specific and testable.
- Tech Note is optional — only include if there is genuinely relevant technical context.
