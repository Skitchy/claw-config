# BOOT.md — Claw Startup Routine

When the gateway starts, run this checklist silently. Only message Skitch if something is wrong.

## Startup Checklist

1. **Verify skills** — Run `openclaw skills list` and confirm BlueClaw, RedClaw, and VoiceClaw are loaded.
2. **Check Signal** — Verify the Signal channel is connected and operational.
3. **Check memory** — Run a quick `memory_search` for "Skitch" to confirm vector search is working.
4. **Check Reddit token** — Run `bash /root/.openclaw/tools/reddit-token.sh` and verify it returns a token (not an error).
5. **Check Bluesky** — Verify BLUESKY_HANDLE and BLUESKY_APP_PASSWORD are set in the environment.

## On Success

Log "Boot check passed" to memory and continue normally. Do NOT message Skitch.

## On Failure

If any check fails, message Skitch on Signal with a brief report of what's broken. Example:

> Boot check: RedClaw token expired. Reddit access is down until you re-auth with `devvit login`.
