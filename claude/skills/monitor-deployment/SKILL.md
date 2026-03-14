---
name: monitor-deployment
description: Monitor a PR post-merge deployment by polling Sentry, Datadog, and CI/CD checks, then send a macOS notification with a health verdict and action recommendation. Use when asked to watch a deployment, monitor after a merge, or track post-deployment health.
---

# Monitor Deployment

Watch a merged (or soon-to-merge) PR and assess deployment health using available
monitoring signals. Send a macOS notification with a clear verdict and recommended
action when the picture is clear enough to act on.

> **Sandbox note:** All `gh` commands require `dangerouslyDisableSandbox: true`.

---

## 1. Parse inputs

Extract from the user's message:

- **PR**: URL or `{OWNER}/{REPO}#{PR_NUMBER}`
- **Tools in use**: ask the user which are available if not obvious —
  Sentry, Datadog, GitHub Actions CI, PagerDuty, custom dashboards

If the PR URL is missing, ask for it before proceeding.

### Check schedule

Before starting, look for a `DEPLOYMENT_MONITOR` config block in the project's
`CLAUDE.md`. If found, use those intervals. Otherwise use the default.

**Default check schedule** (seconds after deploy confirmed live):

| Check | Delay | What it catches |
|---|---|---|
| 1 | 0 s (immediate) | Build/startup failures, crash-on-boot |
| 2 | +30 s | Fast-failing errors, broken routes |
| 3 | +60 s (1 min) | Initial traffic errors |
| 4 | +180 s (3 min) | Stabilising error rates |
| 5 | +600 s (10 min) | Sustained degradation |
| 6 | +1200 s (20 min) | Long-tail issues, slow memory leaks |

Total window: ~34 minutes. Stop early if verdict is `HEALTHY` for two
consecutive checks after check 3, or immediately if verdict is `INCIDENT`.

**Project CLAUDE.md override format** (place in the project's CLAUDE.md):

```
## DEPLOYMENT_MONITOR
check_schedule_seconds: [0, 30, 90, 270, 870, 2070]
# ^ override the delay offsets from deploy-confirmed time
# Tune upward for low-traffic services, downward for high-traffic ones
```

When a custom schedule is found, log it at the start: `Using project check schedule: [...]`

---

## 2. Confirm PR is merged

```bash
gh pr view {PR_NUMBER} --repo {OWNER}/{REPO} \
  --json state,mergedAt,mergeCommit,headRefName,title,baseRefName
```

- If `state` is not `MERGED`, poll every 2 minutes (use `/loop 2m` or tell the
  user to re-run when merged). Do **not** proceed with monitoring until merged.
- Note `mergedAt` — use this as the deployment start time for log/metric queries.

---

## 3. Find the deployment

### GitHub Actions / CI

```bash
gh run list --repo {OWNER}/{REPO} --branch {BASE_REF} --limit 5 \
  --json databaseId,name,status,conclusion,createdAt,url
```

Look for a deploy workflow that started after `mergedAt`. If one is in progress,
poll until it completes:

```bash
gh run watch {RUN_ID} --repo {OWNER}/{REPO}
```

If the deploy workflow failed, skip to **Phase 5: Notify** with verdict `DEPLOY_FAILED`.

### Deployment environments

```bash
gh api repos/{OWNER}/{REPO}/deployments \
  --jq '[.[] | select(.created_at > "{MERGED_AT}") | {id,environment,created_at,ref}]'
```

Check the latest deployment status:

```bash
gh api repos/{OWNER}/{REPO}/deployments/{DEPLOYMENT_ID}/statuses \
  --jq '.[0] | {state,description,log_url}'
```

---

## 4. Run staggered monitoring checks

### 4.0 Determine wall-clock fire times

At the moment the deploy is confirmed live, calculate the absolute time for
each check by adding the schedule offsets to now. Cron has 1-minute resolution,
so checks 1 and 2 (T+0 and T+30s) run synchronously in this session; checks
3–6 are scheduled as one-shot cron jobs.

```
now          = <current wall-clock time>
check_times  = [now, now+30s, now+90s, now+270s, now+870s, now+2070s]
               (or project override offsets if set in CLAUDE.md)
```

### 4.1 Checks 1 & 2 — run immediately and at T+30s

Run check 1 now. Then `sleep 30` and run check 2. These happen synchronously
because 30 seconds is below cron's 1-minute resolution.

At each check, print:
```
[Check N/6 — T+{ELAPSED}s] Running monitoring queries...
```

Run all available monitoring queries (§4a–4d). Skip tools gracefully if
credentials are absent; record which were skipped.

Apply early-exit rules after each check (see below).

### 4.2 Checks 3–6 — schedule as one-shot cron jobs

After check 2, schedule checks 3–6 using `CronCreate` with `recurring: false`.
Compute the cron expression from the wall-clock fire time for each check:

```
check 3 → fire at {HH}:{MM} (T+90s rounded to nearest minute)
check 4 → fire at {HH}:{MM} (T+270s)
check 5 → fire at {HH}:{MM} (T+870s)
check 6 → fire at {HH}:{MM} (T+2070s)
```

Each cron prompt must be self-contained. Use this template:

```
Deployment monitor check {N}/6 for {OWNER}/{REPO}#{PR_NUMBER} ("{PR_TITLE}").
Merged at: {MERGED_AT}. Deploy confirmed at: {DEPLOY_CONFIRMED_AT}. Elapsed: ~T+{OFFSET}s.
Remaining cron job IDs to cancel on early exit: {JOB_ID_LIST}.

Run the monitoring queries from §4a–4d of the monitor-deployment skill.
Synthesise a verdict per §5. Send the macOS notification per §6.
Present findings and recommendation per §7.

Early-exit: if verdict is INCIDENT or DEPLOY_FAILED, call CronDelete on each
remaining job ID. If this is check 4+ and verdict is HEALTHY, and the previous
check was also HEALTHY, call CronDelete on remaining jobs and send a final
"deployment stable" notification.
```

Store all returned job IDs immediately after scheduling so they can be passed
into each prompt and cancelled if needed.

**Early-exit rules (apply after every check):**
- `INCIDENT` or `DEPLOY_FAILED` → cancel all remaining cron jobs, skip to §5
- Check 4 or later + two consecutive `HEALTHY` results → cancel remaining jobs,
  send final healthy notification and stop
- Always complete check 1 regardless of result

### 4a. Sentry

Use the Sentry MCP tools (already configured — no credentials needed):

```
mcp__sentry__search_issues(query="is:unresolved firstSeen:>{MERGED_AT}", limit=20)
```

If a specific issue looks related to the deploy, fetch full details:

```
mcp__sentry__get_issue_details(issue_id="{ISSUE_ID}")
```

Flag as a problem if:
- Any `fatal` or `error`-level issues appeared after `mergedAt`
- Issue count for existing errors spiked more than 2× baseline
- Stack traces reference files or functions changed in this PR

### 4b. Datadog

Requires `DD_API_KEY` and `DD_APP_KEY` in the environment.

```bash
# Error rate metric for the past window
curl -s "https://api.datadoghq.com/api/v1/query" \
  -H "DD-API-KEY: $DD_API_KEY" \
  -H "DD-APPLICATION-KEY: $DD_APP_KEY" \
  -G --data-urlencode "from=$(date -d '{MERGED_AT}' +%s)" \
     --data-urlencode "to=$(date +%s)" \
     --data-urlencode "query=avg:trace.servlet.request.errors{env:production}.as_rate()" \
  | jq '.series[0].pointlist | map(.[1])'
```

Adapt the metric name to match the project's conventions. Ask the user for the
correct service tag/metric if unknown.

Flag as a problem if:
- Error rate is elevated (>2× pre-deploy baseline or above a known SLO threshold)
- P99 latency spiked meaningfully after the deploy

### 4c. PagerDuty (optional)

```bash
curl -s "https://api.pagerduty.com/incidents" \
  -H "Authorization: Token token=$PAGERDUTY_TOKEN" \
  -H "Accept: application/vnd.pagerduty+json;version=2" \
  -G --data-urlencode "statuses[]=triggered" \
     --data-urlencode "statuses[]=acknowledged" \
     --data-urlencode "since={MERGED_AT}" \
  | jq '[.incidents[] | {id,title,urgency,created_at,service}]'
```

Any open high-urgency incident after `mergedAt` is an automatic red flag.

### 4d. GitHub Checks / Status

```bash
gh api repos/{OWNER}/{REPO}/commits/{MERGE_COMMIT_SHA}/check-runs \
  --jq '[.check_runs[] | {name,status,conclusion,details_url}]'
```

---

## 5. Synthesise verdict

Evaluate all signals and assign one of four verdicts:

| Verdict | Meaning |
|---|---|
| `HEALTHY` | No errors, no anomalies, all checks green |
| `DEGRADED` | Minor error spike or partial check failure — elevated risk |
| `INCIDENT` | Active errors, paging alerts, or failed checks |
| `DEPLOY_FAILED` | The deploy workflow itself did not succeed |
| `UNKNOWN` | Too many checks were skipped to make a reliable call |

---

## 6. Send macOS notification

```bash
osascript -e 'display notification "{BODY}" with title "Deployment: {VERDICT}" subtitle "{PR_TITLE}" sound name "{SOUND}"'
```

Sound mapping:
- `HEALTHY` → `"Glass"`
- `DEGRADED` → `"Purr"`
- `INCIDENT` / `DEPLOY_FAILED` → `"Basso"`
- `UNKNOWN` → `"Tink"`

Body format (keep under 100 chars):
- `HEALTHY`: `"All checks green at T+{ELAPSED}. No action needed."`
- `DEGRADED`: `"Check {N}: error spike at T+{ELAPSED}. Monitor — see Claude."`
- `INCIDENT`: `"URGENT: Active errors at T+{ELAPSED}. Immediate action required."`
- `DEPLOY_FAILED`: `"Deploy workflow failed. PR changes not in production."`
- `UNKNOWN`: `"Check {N}: incomplete data at T+{ELAPSED}. Manual check needed."`

---

## 7. Present findings and recommendation

Print a concise report in the conversation:

```
## Deployment Health: {VERDICT}
PR: {TITLE} (#{PR_NUMBER})
Merged: {MERGED_AT}
Monitoring window: {N} min

### Signals
- GitHub Actions: {pass/fail/skipped}
- Sentry:        {clean/N new errors/skipped}
- Datadog:       {normal/elevated/skipped}
- PagerDuty:     {no incidents/N open/skipped}

### Recommendation
{see below}
```

### Recommendation by verdict

**HEALTHY**
> All signals are green. No action required. Consider updating your ticket/PR
> as successfully deployed.

**DEGRADED**
> Error rate is elevated but not critical. Continue monitoring for the next
> {N} minutes. If it doesn't recover, prepare a rollback. Do not deploy
> further changes until stable.

**INCIDENT**
> Active errors detected after this deploy. Recommended actions in order:
> 1. **Revert** — if the change is isolatable and a revert is low-risk:
>    `gh pr revert {PR_NUMBER} --repo {OWNER}/{REPO}`
> 2. **Hotfix** — if reverting would cause more disruption, prepare a targeted
>    fix on a new branch and fast-track it through review.
> 3. **Feature flag** — if the feature can be toggled off without a deploy,
>    disable it immediately and investigate.
>
> Alert your team now. Do not wait for auto-recovery.

**DEPLOY_FAILED**
> The deploy pipeline did not complete. Production is unchanged.
> Check the workflow logs: {RUN_URL}
> Fix the pipeline issue and re-trigger the deploy, or escalate to the
> platform/infrastructure team if the failure is not in your code.

**UNKNOWN**
> Not enough monitoring data was available to make a reliable assessment.
> Manually verify error rates in Sentry/Datadog before declaring the deploy
> healthy. Checks skipped: {LIST}.

---

## Resuming after an incident

If the user resolves an `INCIDENT` (reverts, hotfixes, or feature-flags the
issue) and wants to re-verify, first cancel any remaining cron jobs from the
previous run (`CronList` → `CronDelete` each), then run the skill again from
scratch. The new run restarts the check schedule from T+0 against the new deploy.

> **Session caveat:** cron jobs are session-only. If Claude exits, all scheduled
> checks are lost. For unattended overnight monitoring, use an external scheduler
> (GitHub Actions workflow dispatch, system cron) that re-invokes Claude via API.

---

## Rules

- Never revert or take production action without explicit user confirmation
- Always report which checks were skipped so the user can judge confidence
- Keep notifications short — they're alerts, not reports; the report lives here
- If Sentry/Datadog credentials are missing, tell the user what env vars are needed
- Do not fabricate metrics — if a query fails, record it as skipped
