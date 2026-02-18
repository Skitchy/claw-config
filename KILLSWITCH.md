# KILLSWITCH.md — Platform & Feature Controls

## Platform Posting
- bluesky: ENABLED
- reddit: ENABLED
- x: DISABLED (skill ready, needs manual browser login first)
- hackernews: DISABLED (not yet built)

## Feature Controls
- marketclaw-alerts: ENABLED
- shopclaw-content: ENABLED
- canvas-refresh: DISABLED (Canvas not yet configured)

## Rules
Before ANY write operation (post, comment, reply) on a platform:
1. Read this file
2. Check the platform status above
3. If DISABLED — do not post, log the attempt to AUDIT.md
4. If ENABLED — proceed with normal guardrails from SOUL.md

Before ANY autonomous feature action:
1. Check the feature control above
2. If DISABLED — suppress the action, log to AUDIT.md
3. If ENABLED — proceed normally

## Override
Skitch can enable/disable platforms and features at any time via Signal message or by editing this file directly.
