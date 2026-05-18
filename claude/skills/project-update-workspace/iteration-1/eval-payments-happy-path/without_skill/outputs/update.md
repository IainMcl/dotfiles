**#platform-updates — Dotfiles / Dev Tooling | Week of Mar 6–12**

Here's what shipped in the personal dev tooling this week.

**Claude Code improvements (biggest focus this week)**

The Claude Code setup got a meaningful round of hardening and capability work:

- PRs now include frontend screenshots by default. The `create-draft-pr` skill was updated to trigger Playwright to capture screenshots or recordings for any UI-touching changes and attach them to the PR description — less back-and-forth asking "what does this look like?"
- Fixed a persistent sandbox issue affecting all GitHub CLI-based skills (`create-draft-pr`, `review-pr`, `address-pr-comments`, `code-review`). `gh` commands were failing due to TLS verification errors inside the sandbox; all affected skills now document the required workaround.
- Vault reads are now permitted in the Claude sandbox on Mac, so Claude can access Obsidian notes directly without needing the MCP server.
- Claude now sends a desktop notification (via OSC 9) when it finishes a task, so you don't have to watch the terminal.
- Sandbox config and `skipDangerousModePermissionPrompt` added to `settings.json` to reduce friction on trusted operations.

**WezTerm terminal**

- Tab titles now correctly track the current working directory even when a program (e.g. a server) is running in the foreground. Previously the CWD would get "stuck" — fixed by switching to the pane API and sourcing WezTerm's OSC 7 shell integration in zsh.
- Inactive tabs with new unseen output now show a blue dot indicator, making it easier to spot when a background process finishes.

**Minor**

- Obsidian note skill: added a rule to prevent quoting hub values in frontmatter (was causing parsing issues).

No blockers. Next likely focus: continued Claude skill reliability and possibly tidying the install scripts.
