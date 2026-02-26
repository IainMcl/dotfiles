---
name: create-draft-pr
description: Create a draft PR using the gh CLI
---

# create-draft-pr

Create a draft PR using the `gh` CLI.

## Check changes
First inspect the status, diff, and recent commits to understand the changes.

## Identify a PR template
Then check for a PR template in common locations: `.github/PULL_REQUEST_TEMPLATE.md` `github/pull_request_template.md`, or `PULL_REQUEST_TEMPLATE.md` at repo root.
If a template is found use it to base the body and fill in the summary.
If there are database migrations as part of the changes ensure that the SQL changes even if a no-op are included in the PR description.
If the template requires a Jira link and provides a root URL, use the root URL and find the relevant ticket number from the branch name. Git branches are often named like `APP-107366-file-safety-validation` where  `APP-107366` will be used for the URL - example full URL: https://travelperk.atlassian.net/browse/APP-107366 .

## Things to include

If there are post deployment steps, include them in the PR description.
If there are any post deployment tests that need to be run, include them in the PR description.

## Things not to include

Do **not** include a description of files changed.  **Only** describe the high
level changes.  If there are points that a reviewer should pay particular
attention to.  Then after creating the draft PR, add a comment on the specific
lines explaining what should be looked at.

## Create draft PR
Create a draft PR using the command:

```bash
gh pr create --draft --title \"{title}\" --body \"{body}\"
```

Return the URL.

## If the current branch isn't published

If the current branch is not published, push with `-u`.

## Signing

Don't use any form of signing at the end of a draft pull request or commits
so don't add `-agent`, `-Claude`, or `written with...`.
