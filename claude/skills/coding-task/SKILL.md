---
name: coding-task
description: Load this skill when starting any coding task. Guides reading project documentation and loading appropriate skills.
autoload: coding
---

# Software Task Workflow

When starting any coding task, follow this workflow to ensure you have the right context and tools.

## 1. Read Project Documentation

**Always read the project README first:**

```
README.md
README.rst
README
```

Look in the working directory root. The README contains critical instructions for:
- Building the project
- Installing dependencies
- Running tests
- Development workflows
- Project-specific conventions

## 2. Identify Required Skills

**Load skills proactively** - don't wait to be asked. If working on a Jira ticket, fetch the ticket details first. If writing code, know how to run tests.

## 3. Follow the Chain of Authority

When instructions conflict, follow this priority:

1. **User instructions** (highest priority)
2. **Project README** and `CLAUDE.md`
3. **Loaded skills**
4. **General best practices**

## 4. Before Writing Code

- Understand the existing codebase patterns
- Read related files to understand conventions
- Check if there are existing tests to follow as examples
- Know how to run tests for the code you're changing

## 5. After Writing Code

- Run tests scoped to your changes
- Build/compile if the project requires it
- Follow commit conventions from the project

## Key Reminders

- **Don't guess** - read the README for project-specific commands
- **Don't assume** - different projects have different conventions
- **Load skills early** - have the right tools ready before you need them
- **Test your changes** - always verify code works before committing
