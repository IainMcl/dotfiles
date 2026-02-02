# Coding guidelines

## Starting new work

**Always** read the project's README and CONTRIBUTING files before starting work
in a new thread.

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
