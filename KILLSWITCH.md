# KILLSWITCH.md — Platform Posting Controls

## Status
- bluesky: ENABLED
- reddit: ENABLED
- hackernews: DISABLED (not yet built)
- x: DISABLED (not yet built)

## Rules
Before ANY write operation (post, comment, reply) on a platform:
1. Read this file
2. Check the platform status above
3. If DISABLED — do not post, log the attempt to AUDIT.md
4. If ENABLED — proceed with normal guardrails from SOUL.md

## Override
Skitch can enable/disable platforms at any time via Signal message or by editing this file directly.
