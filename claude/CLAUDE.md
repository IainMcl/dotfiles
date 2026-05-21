@~/.claude/rules/aws-mcp.md

# Coding guidelines

## No attribution

Never add "Generated with Claude Code", `Co-Authored-By`, or similar attribution to commits, PRs, code comments, or any output. Exception: when replying to PR comments, sign off with `-Claude`.

## Make invalid state impossible

Prefer types that cannot represent invalid states over nullable/optional values:

- Avoid `| None` and optional fields unless `None` is a genuinely meaningful state distinct from "not present"
- Return `None` from a function to signal absence; don't use an empty object with nullable fields
- When two values are always set together, put them in a required-field model rather than two separate optionals
- Prefer `X | Y` union types or distinct return types over a single type where some fields may be unpopulated

## Punctuation

Never use em dashes (—). Use a hyphen (-) instead. This applies to all output: notes, docs, code comments, PRs, Slack messages, everything.

## Comments

- Only explain *why*, not *what*. Make code self-explanatory through naming and structure.

## Function ordering

Define callers before callees — top-down reading flow.

## Code Style & Patterns

Always use existing service abstractions and patterns from the codebase rather than implementing direct/raw approaches. When fixing bugs, investigate the established patterns first.

Before implementing anything, search the codebase for existing patterns that handle similar functionality. Show 2-3 examples of how the team has solved analogous problems, then propose an approach that follows those patterns. Do not write any code until the approach is approved.

## PR Reviews

When reviewing PRs, NEVER post comments directly to the PR unless explicitly asked. Walk through suggestions interactively in-conversation only.

## Branch discipline

- Never work directly on `main`. If on `main`, ask before proceeding.
- Branch from up-to-date `origin/main`. If branching from elsewhere, ask first.

## Python / Typing

When fixing mypy/type errors, be cautious about approaches: avoid `type: ignore` and `cast()` as first attempts - they often cause secondary CI failures (redundant-cast, etc.). Prefer mypy.ini overrides or structural fixes.

## Language-specific skills

When working in a particular language, look for a matching skill (e.g. `python-coding` for Python).

## Obsidian vault

Notes are at `$VAULTS_PATH` (set per machine in shell profile). Prefer reading notes directly with `Read` or `Grep` over using the Obsidian MCP server — direct reads are cheaper. Only use the MCP when you need fuzzy search across the vault and don't know which file to look in.

## Git commit format

Do NOT use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, `feat(scope):`, etc.) in commit messages, PR titles, or anywhere else. Use plain imperative sentences instead (e.g. "Add gopls LSP", "Fix NVM path not visible to Neovim").

**Never** use `$()` command substitution or HEREDOC for commit messages — this triggers a security confirmation prompt. Instead:
1. Use the `Write` tool to write the commit message to `$TMPDIR/commit_msg.txt`
2. Run `git commit -F $TMPDIR/commit_msg.txt`

## Writing & Documentation

Post-mortems and incident debriefs should use blameless, conversational language. Avoid overly formal or blame-oriented tone. Do not make claims that aren't directly supported by evidence in the codebase or logs.

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
