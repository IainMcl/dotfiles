---
name: check-ci
description: Monitor CI checks on a GitHub PR (GitHub Actions and CircleCI), investigate failures, implement fixes, and re-push. Use when CI is failing on a PR or immediately after creating one.
---

# check-ci

Monitor CI checks on a GitHub PR, investigate failures, implement fixes, and re-push until all checks pass. Handles both GitHub Actions and CircleCI.

## Identify the PR

If a PR URL or number was passed as an argument, use it.

Otherwise detect the open PR for the current branch:

```bash
gh pr view --json number,url,headRefName
```

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true` — the sandbox breaks TLS verification for GitHub API calls. Always set this flag for every `gh` invocation.

If no open PR is found, report this to the user and stop.

## Wait for checks to complete

Poll until all checks have reached a terminal state (not queued or in_progress):

```bash
gh pr checks {PR_NUMBER} --watch --interval 30
```

If all checks pass, report success and stop.

## Identify failures

Fetch full check details to classify each failure by provider:

```bash
gh pr checks {PR_NUMBER} --json name,status,conclusion,link
```

For each check where `conclusion` is `failure`, record the `name` and `link`.

## Fetch failure logs

Determine the provider from the `link` field.

### GitHub Actions

Link pattern: `https://github.com/{owner}/{repo}/actions/runs/{run_id}/...`

Extract the `run_id` and fetch failed step output:

```bash
gh run view {RUN_ID} --log-failed
```

### CircleCI

Link pattern: `https://app.circleci.com/pipelines/github/{owner}/{repo}/{pipeline_number}/workflows/{workflow_id}`

Extract the `workflow_id`. List the jobs in that workflow using the CircleCI v2 API:

```bash
curl -s -H "Circle-Token: ${CIRCLECI_TOKEN}" \
  "https://circleci.com/api/v2/workflow/{workflow_id}/job"
```

For each failed job, fetch its log output via the v1.1 API (which returns the full step-by-step output):

```bash
curl -s -H "Circle-Token: ${CIRCLECI_TOKEN}" \
  "https://circleci.com/api/v1.1/project/github/{owner}/{repo}/{job_number}/output"
```

The response is a JSON array of step outputs - look for steps where `failed: true` and read their `message` content.

**Fallback ordering if `CIRCLECI_TOKEN` is unset:**

1. Try the `circleci` CLI if available: `circleci workflow get {workflow_id}`
2. If neither is available, surface the CircleCI link(s) to the user, ask them to paste the failure output, and wait before continuing.

## Retry tracking

Track each distinct failure by `(check_name, error_fingerprint)` where the fingerprint is the first meaningful error line (e.g. the failing test name, the lint rule, the import error). For each unique `(check_name, error_fingerprint)` pair, attempt a fix up to **3 times**.

Key rules:
- Fixing failure A which then reveals failure B does not consume any of B's retries - B gets its own independent count from zero.
- Only give up on a specific failure after 3 unsuccessful fix attempts for that exact same failure.
- If a fix resolves failure A but A reappears in a later run with a different error fingerprint, treat it as a new failure.

If any failure reaches its retry limit, stop, summarise what was tried for each exhausted failure, and hand back to the user.

## Investigate and fix

Before making any changes, read the source files identified in the failure output. Understand the root cause and state it clearly.

Apply the minimal change to fix the failure:

- **Lint / formatting failures** - apply the formatter or fix the specific rule violation.
- **Type errors** - follow the Python/typing guidance in CLAUDE.md; prefer structural fixes over `type: ignore` or `cast()`.
- **Test failures** - read both the test and the implementation. Determine whether the expectation or the implementation is wrong before changing anything.
- **Build / import errors** - trace the error back to the source file before touching anything.

If a language-specific skill applies (e.g. `python-coding` for Python), activate it before making changes.

Do not fix multiple unrelated failures in a single commit. One logical fix per commit.

## Commit and push

Write the commit message to `/tmp/commit_msg.txt` then commit:

```bash
git commit -F /tmp/commit_msg.txt
git push
```

Never use `$()` substitution or HEREDOC for commit messages.

After pushing, return to **Wait for checks to complete**.
