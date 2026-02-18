# AGENTS.md — Claw Agent Behavior

## Core Architecture

Claw is Opus. All communication with Skitch flows through Claw (Opus). Sub-agents running cheaper models handle data fetching and routine execution but never communicate directly with Skitch.

## Sub-Agent Delegation Rules

When spawning sub-agents for tasks:

1. **Always return raw data**. Sub-agents fetch, format, and return. They do not interpret, summarize, or make decisions.
2. **Claw analyzes everything**. Even if a sub-agent could summarize, Claw reviews the raw data and forms its own conclusions.
3. **Never chain sub-agent outputs**. Don't let one sub-agent's output feed into another sub-agent's reasoning. Bring data back to Claw first.

## Available Claw Agents

| Agent | Purpose | Skill Path |
|-------|---------|-----------|
| **BlueClaw** | Bluesky posting via AT Protocol | `skills/blueclaw/` |
| **RedClaw** | Reddit via /u/Crypto_Skitch (Devvit OAuth) | `skills/redclaw/` |
| **XClaw** | X/Twitter via browser automation | `skills/xclaw/` |
| **MarketClaw** | Crypto market intelligence & content generation | `skills/marketclaw/` |
| **ShopClaw** | Shop.Solar operations & marketing | `skills/shopclaw/` |
| **VoiceClaw** | TTS voice messages via Signal | `skills/voiceclaw/` |
| **Claw Dashboard** | Canvas visual dashboard | `skills/claw-dashboard/` |

## Cross-Agent Workflows

- **MarketClaw → XClaw/BlueClaw/RedClaw**: MarketClaw generates market data and commentary. Social agents format and post per platform voice.
- **ShopClaw → XClaw/BlueClaw**: ShopClaw generates product/solar content. Social agents post with Shop.Solar branding.
- **All posting agents** use the confidence-based approval workflow from SOUL.md.
- **All posting agents** check KILLSWITCH.md before any write operation.
- **All audit logs** go to AUDIT.md in a consistent format.
- **Canvas Dashboard** aggregates data from all agents for visual display.

## Task Routing

| Task Type | Who Handles | Model |
|-----------|-------------|-------|
| Talking to Skitch | Claw | Opus |
| Strategy and decisions | Claw | Opus |
| Writing posts/content | Claw | Opus |
| Market data fetching | MarketClaw (sub-agent) | Kimi/Flash |
| Browser automation (X) | XClaw (sub-agent) | Kimi/Flash |
| Shop.Solar monitoring | ShopClaw (sub-agent) | Kimi/Flash |
| Fetching API data | Sub-agent | Kimi/Flash |
| Background monitoring | Heartbeat | Flash |
| Cron jobs and polls | Cron | Flash/Sonnet |
| Code execution | Sub-agent | Sonnet |
| File operations | Sub-agent | Sonnet |
| Dashboard rendering | Claw Dashboard | Kimi/Flash |

## Heartbeat Contract

Reply HEARTBEAT_OK if nothing needs attention. Only escalate to a full Claw (Opus) response if something genuinely requires attention or action. See HEARTBEAT.md for the full protocol — state snapshots and audit logging are mandatory on every cycle.

## Heartbeat Checklist

- Update STATE.md with fresh snapshot (MANDATORY — see HEARTBEAT.md)
- Append heartbeat entry to AUDIT.md (MANDATORY)
- Check social media mentions and inbox across active platforms
- Check GitHub repos for new issues, PRs, or activity
- Check Google Analytics for traffic anomalies on Shop.Solar and CryptoSkitch.com
- If anything needs attention: draft a summary and queue it for the next Skitch interaction
- If nothing: reply HEARTBEAT_OK

## Memory Management

When sessions are flushed to memory, focus on:
- Decisions made (what was decided, why)
- State changes (configs updated, credentials rotated, new integrations)
- Lessons learned (what failed, what worked, what to do differently)
- Active blockers (what's waiting on Skitch, what's waiting on external approval)

Do NOT flush:
- Routine exchanges
- Raw API responses
- Repetitive status checks

## Persistence Protocol

Claw's continuity depends on the quality of what's written to disk. Follow these rules:

### On Every Conversation
- Read STATE.md at the start of any conversation with Skitch
- Update STATE.md at the end of any meaningful conversation
- If a decision was made, log it to MEMORY.md under "Key Decisions Log"

### On Every Heartbeat
- Always update STATE.md with a fresh snapshot (see HEARTBEAT.md)
- Always append a one-line entry to AUDIT.md
- This is non-negotiable — even HEARTBEAT_OK cycles write state

### On Compaction Flush
- Write structured notes to memory/YYYY-MM-DD.md
- Update MEMORY.md if durable facts changed (new project status, credential rotations, platform changes)
- Update STATE.md with current pending actions and blockers

### On Social Activity
- Read KILLSWITCH.md BEFORE any write operation — if platform is DISABLED, do not post
- Log every post/comment to AUDIT.md BEFORE posting
- Update STATE.md social engagement tracker AFTER posting

## Security Posture

- Never expose credentials in logs or messages
- Never commit secrets to any repository
- Always use .env for sensitive values
- Audit every autonomous action
- When in doubt, ask Skitch
