---
name: ticket-writer
description: Write and create Jira tickets using acli. Use when creating task or bug tickets in the TK-APP project.
---

# Ticket Writer

Creates well-structured, actionable Jira tickets in the TK-APP project using the Atlassian CLI (`acli`).

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
- **Component**: `Vat & Invoicing`
- **Epic/Parent**: check for a relevant open epic before creating — search with `acli jira issue list --project TK-APP --type Epic` and link if appropriate

## Process

1. **Infer from context** — determine ticket type, title, description, and tech notes from the information provided. Only ask for what is genuinely missing.
2. **Always ask for priority** — do not infer priority. Ask the user: Highest / High / Medium / Low / Lowest.
3. **Check for a relevant epic** — search for open epics in TK-APP and ask the user if one applies.
4. **Draft the ticket** — show the full ticket draft to the user for review before creating.
5. **Create with acli** — once approved, create the ticket using acli.

## acli commands

```bash
# Create a ticket — write body to file first, never use inline command substitution
echo "ticket body" > /tmp/ticket_body.md
acli jira issue create \
  --project TK-APP \
  --type Task \
  --summary "Ticket title" \
  --description "$(cat /tmp/ticket_body.md)" \
  --priority Medium \
  --component "Vat & Invoicing" \
  --parent EPIC-123

# List open epics
acli jira issue list --project TK-APP --type Epic --status "In Progress"
```

## Constraints

- Always show the full draft to the user before creating the ticket.
- Do not create the ticket without user approval.
- Acceptance criteria must be specific and testable.
- Tech Note is optional — only include if there is genuinely relevant technical context.
