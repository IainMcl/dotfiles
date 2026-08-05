---
name: create-draft-pr
description: Create a draft PR using the gh CLI
---

# create-draft-pr

Create a draft PR using the `gh` CLI.

## Check changes
First inspect the status, diff, and recent commits to understand the changes.

## Identify a PR template
Then check for a PR template in common locations:
`.github/PULL_REQUEST_TEMPLATE.md` `github/pull_request_template.md`, or
`PULL_REQUEST_TEMPLATE.md` at repo root.
If a template is found use it to base the body and fill in the summary.
If there are database migrations as part of the changes ensure that the SQL
changes even if a no-op are included in the PR description.
If the template requires a Jira link and provides a root URL, use the
root URL and find the relevant ticket number from the branch name. Git
branches are often named like `APP-107366-file-safety-validation`
where  `APP-107366` will be used for the URL - example full URL:
https://travelperk.atlassian.net/browse/APP-107366 .

## Things to include

If there are post deployment steps, include them in the PR description.
If there are any post deployment tests that need to be run, include them in the PR description.

## Things not to include

Do **not** include a "Changes", "What changed", "Files changed", or any section
that lists modified files or enumerates what was added/removed. GitHub has a diff
tab that shows this - repeating it in the description is redundant noise. The
rare exception is when a specific file or area of the diff carries non-obvious
risk or deserves particular reviewer attention - in that case, call it out in
prose as a targeted note, not as a list of changed files.

Do **not** include a description of files changed. **Only** describe the high
level changes. If there are points that a reviewer should pay particular
attention to, add a comment on the specific lines after creating the draft PR.

Do **not** include a "How to test", "Testing", or "Test plan" section unless
there are involved practical pre- or post-deployment steps that a person must
carry out manually (e.g. running a one-off migration script, verifying a third-party
webhook in staging, coordinating a feature flag flip). Things like "run the test
suite", "run linting", or "open the app and click around" are not worth including -
CI covers automated checks, and basic smoke testing is implied. When in doubt, omit
the section entirely.

## Frontend change screenshots

After reviewing the diff, evaluate whether the changes include **frontend/UI
modifications** (e.g. component changes, styling updates, layout shifts, new
pages or modals). If so, decide whether the PR would benefit from a screenshot
or screen recording to help reviewers understand the visual impact.

If a screenshot or recording would add value:

1. Use the **Playwright MCP** tools to launch the app and navigate to the
   affected page(s).
2. Capture a screenshot (or screen recording for interactive/animated changes).
3. The `gh` CLI **cannot** upload images to PRs. Instead:
   - Save the screenshot to `docs/screenshots/<ticket>-<description>.png`
   - Commit it to the branch and push
   - Reference it in the PR body using a blob URL:
     ```markdown
     ![Description](https://github.com/OWNER/REPO/blob/BRANCH/docs/screenshots/FILE.png?raw=true)
     ```
   - This works for private repos since the viewer is authenticated on GitHub.

Skip this step if the changes are purely backend, configuration, or
non-visual.

## Create draft PR

> **Sandbox note:** `gh pr create` fails inside the sandbox with a TLS certificate error (`x509: OSStatus -26276`) even with `dangerouslyDisableSandbox: true`. Always use the GitHub REST API via `curl` instead:

1. Get the token: `gh auth token`
2. POST to the pulls endpoint:

```bash
curl -s -X POST \
  -H "Authorization: token $(gh auth token)" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/{owner}/{repo}/pulls \
  -d "{\"title\": \"...\", \"head\": \"branch-name\", \"base\": \"main\", \"draft\": true, \"body\": \"...\"}"
```

`curl` does not have the same TLS restriction and reaches GitHub successfully from within the sandbox.

Return the `html_url` from the response.

## If the current branch isn't published

If the current branch is not published, push with `-u`.

## Monitor CI checks

After the PR is created, activate the `check-ci` skill, passing the PR URL as the argument. It will wait for all checks to complete, investigate any failures, implement fixes, and re-push automatically.

