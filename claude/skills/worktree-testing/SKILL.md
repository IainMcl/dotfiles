---
name: worktree-testing
description: Guide for testing changes locally when working in a Claude Code worktree. Use when running dev servers, tests, or verifying changes in a worktree.
---

# Testing in Claude Code Worktrees

Worktrees (`claude -w <name>`) create an isolated copy of the repo at
`.claude/worktrees/<name>/` on a new branch `worktree-<name>`.

## Setup

Dependencies are not pre-installed in a new worktree. Install them before
running anything:

```bash
# Frontend
cd frontend && npm install

# Backend
cd backend && pip install -e ".[dev]"
```

## Running dev servers

Run `just run` or individual dev commands as normal — the worktree is a full
working copy.

**Port conflicts**: If the main repo is already running dev servers, the
worktree will fail to bind the same ports. Stop the main instance first or
configure different ports.

## Testing from a separate terminal

Open another terminal and `cd` into the worktree directory to run servers,
curl endpoints, or open the browser while Claude works in the session:

```bash
cd .claude/worktrees/<name>/
just run
```

## Cleanup

When exiting the Claude session:
- **No changes made**: worktree and branch are deleted automatically
- **Changes made**: Claude prompts whether to keep or remove the worktree
