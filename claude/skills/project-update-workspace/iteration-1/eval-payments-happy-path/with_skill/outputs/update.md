*Dotfiles — past 7 days*

✅ *Done*
• Shipped WezTerm tab indicators: inactive tabs now show a blue dot when there's unseen output, so it's easier to track background work at a glance
• Fixed WezTerm CWD tracking — tab titles now persist correctly when programs are running (using the pane API + OSC 7 shell integration)
• Added Claude Stop hook: a desktop notification fires when Claude finishes a task, so you don't have to watch the terminal
• Improved the `create-draft-pr` skill to auto-capture Playwright screenshots/recordings for UI changes and attach them to PRs
• Added sandbox config to Claude settings, eliminating repeated permission prompts for safe operations
• Fixed an Obsidian note skill edge case: hub values in frontmatter are no longer incorrectly quoted

🔄 *In Progress*
• Ongoing refinement of Claude skills — sandbox handling notes added to all gh-based skills to prevent TLS failures

👀 *Up Next*
• Further polish to skill workflows based on recent eval runs
