# HEARTBEAT.md

CONTRACT: On every heartbeat, update STATE.md with current status BEFORE deciding whether to escalate.

## Step 1: State Snapshot (ALWAYS do this)

Read STATE.md. Update these sections with fresh data:
- **Recent Activity Summary** — last 24h only, max 5 items. Remove anything older.
- **Social Engagement Tracker** — posts/comments today, reset counts if new day.
- **System Health** — token status, connection status, last heartbeat timestamp.
- **Pending Actions** — anything still waiting on Skitch or external action.
- **Active Blockers** — anything stuck and why.

Write the updated STATE.md with current UTC timestamp in the header.

## Step 2: Audit Log Entry

Append a one-line entry to AUDIT.md:
`[YYYY-MM-DD HH:MM UTC] HEARTBEAT — [brief status: e.g. "all clear" or "bluesky token expiring in 1h"]`

This creates a verifiable trail that heartbeats are running.

## Step 3: Quick Scan

- Any urgent messages or mentions across social platforms?
- Any new GitHub issues or PRs on monitored repos (Fortress-System, RedClaw, BlueClaw)?
- Any kill switches triggered? (Read KILLSWITCH.md)
- Any token expirations within the next 2 hours?
- Google Analytics — traffic spikes on Shop.Solar or CryptoSkitch.com?

## Step 4: Decision

- If something needs Skitch's attention — Draft a concise summary, queue it for next interaction via Signal. Include: what happened, recommended action, confidence level, whether it needs approval.
- If nothing needs attention — Reply HEARTBEAT_OK

## Step 5: Memory Hygiene (rotate through these, one per day)

Pick ONE of these each day, cycling through:
- **Monday**: Review MEMORY.md for outdated info and clean it up
- **Tuesday**: Check if any pending actions in STATE.md have resolved
- **Wednesday**: Archive completed items from STATE.md
- **Thursday**: Check KILLSWITCH.md matches actual platform availability
- **Friday**: Review AUDIT.md — flag any anomalies in posting patterns
- **Weekend**: Skip hygiene, just do Steps 1-4
