# Coding guidelines

## Starting new work

**Always** read the project's README and CONTRIBUTING files before starting work
in a new thread.

## Making changes

When making changes ensure that you are on a relevant branch. Very rarely
should work be done directly on the main branch. If you are unsure about
which branch to work on, ask for guidance.

When creating new branches make sure to branch from the most up to date
version of origin main. If there are cases where you need to branch from
a different branch, make sure to pull the latest changes from that branch
before creating your new branch. Ideally in these cases ask before branching
not from origin main.

## Comments

- Only add comments that explain *why* something non-obvious or hacky is happening.
- Avoid comments that explain *what* the code is doing; instead, make the code
  self-explanatory through clear naming and structure.
- Don't sign work saying "Generated with Claude Code" or similar attribution. Keep
  comments focused on explaining the code itself.

## Module imports

Avoid using function level imports wherever possible.  All imports should be at
the top of the file.  The only exceptions to this are if there are issues with
top level imports like circular imports.

## Function Ordering

When writing functions that depend on each other, keep the ordering intuitive:
- If function A calls function B, define function A first, then function B underneath
- The caller should appear before the callee
- This creates a top-down reading flow where high-level logic comes before implementation details

## Creating Pull Requests

- Follow the project's CONTRIBUTING guidelines for PR creation.
- Look for PR templates in the repository root or `.github/PULL_REQUEST_TEMPLATE.md`.
- Use the `gh` CLI to create draft PRs with appropriate titles and bodies.
- If the template requires a Jira link, extract the ticket number from the branch name.

## Committing and Pull request descriptions

Do not sign off commits and pull request descriptions saying "Generated with Claude Code" or similar.
When replying to comments on pull requests only sign off with `-Claude`.

## Improving AI agents

When completing work if there are commands or workflows that fail - For example
getting comments from a GitHub PR - please ask if we should add a new skill with
the correct resolution or update an existing skill that led to failing commands.

## Token Efficiency — IMPORTANT

CLAUDE MUST warn the user if any of these patterns appear, before spending tokens on them:

| Pattern | Warning to give |
|---|---|
| Vague task with no file refs or success criteria | "What files are involved? How will we verify this is correct?" |
| "Investigate / explore / look into" without a scope | "This could read many files. Should I use a subagent, or can we scope it to specific files/directories?" |
| Correcting the same mistake a second time | "We've corrected this twice. Let's `/clear` and rewrite the prompt with what we've learned." |
| Mixing unrelated tasks in the same session | "This looks unrelated to the current task. Run `/clear` first to avoid noisy context." |
| Jumping to implementation on a complex/multi-file change | "Should we explore + plan first before coding? Use Plan Mode (`Shift+Tab`) for uncertain changes." |
| No verification criteria for a coding task | "How will we verify this works? A test, a command, or expected output to check against?" |
| Simple/read-only request (lookup, explanation, single-file search) being handled by Sonnet/Opus | "This looks like a simple task. Consider switching to Haiku (`/model haiku`) to save cost and latency." |
| Using Opus for a task that isn't: frontier reasoning on the hardest problems, sustained multi-file agentic coding, or deep multi-step web research | "Sonnet 4.6 matches or beats Opus on most coding and document tasks at ~40% of the cost. Switch with `/model sonnet`." |

When compacting, always preserve: the list of modified files, any API endpoints being worked on, and which verification steps have been completed.

### Dynamic model shifting

**Before** getting deep into a task decide which available AI model is most
appropriate for the task.  If the currently selected model is not best for the
task suggest to the user to switch models.
