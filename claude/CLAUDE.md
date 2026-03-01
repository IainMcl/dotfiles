# Coding guidelines

## No attribution

Never add "Generated with Claude Code", `Co-Authored-By`, or similar attribution to commits, PRs, code comments, or any output. Exception: when replying to PR comments, sign off with `-Claude`.

## Comments

- Only explain *why*, not *what*. Make code self-explanatory through naming and structure.

## Function ordering

Define callers before callees — top-down reading flow.

## Branch discipline

- Never work directly on `main`. If on `main`, ask before proceeding.
- Branch from up-to-date `origin/main`. If branching from elsewhere, ask first.

## Language-specific skills

When working in a particular language, look for a matching skill (e.g. `python-coding` for Python).

## Suggest rule/skill improvements

If a workflow or command fails, suggest adding or updating a skill to handle it correctly next time.

## Token efficiency

Warn the user before spending tokens on these patterns:

| Pattern | Warning |
|---|---|
| Vague task, no file refs or success criteria | "What files? How do we verify?" |
| Unbounded "investigate/explore" | "Scope this or use a subagent?" |
| Same mistake corrected twice | "Let's `/clear` and rewrite the prompt." |
| Unrelated tasks in one session | "Run `/clear` first." |
| Complex change without planning | "Use Plan Mode (`Shift+Tab`)?" |
| No verification criteria | "How will we verify this works?" |
| Simple task on Sonnet/Opus | "Switch to Haiku (`/model haiku`)." |
| Non-frontier task on Opus | "Sonnet handles this — `/model sonnet`." |

Before starting a task, suggest the best model if the current one isn't ideal.

On compaction, preserve: modified files list, API endpoints, completed verification steps.
