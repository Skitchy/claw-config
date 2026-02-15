# claw-config

Private configuration repository for the Claw ecosystem. Contains OpenClaw agent configuration, workspace files, and deployment scripts.

**This repo is private.** It contains configuration templates but never secrets.

## What's Here

| File | Purpose |
|------|---------|
| `openclaw.json` | OpenClaw config template (secrets via `${...}` placeholders resolved from `.env`) |
| `SOUL.md` | Claw's personality, voice, and social posting guardrails |
| `AGENTS.md` | Agent behavior rules and sub-agent delegation patterns |
| `USER.md` | Information about Skitch for Claw's context |
| `HEARTBEAT.md` | Heartbeat checklist for background monitoring |
| `deploy.sh` | Git polling script for cron-based deployment |
| `BLUECLAW.md` | BlueClaw skill definition |
| `REDCLAW.md` | RedClaw skill definition |
| `.env.example` | Template for VPS secrets (copy to `~/.openclaw/.env`) |

## Deployment

This repo is polled every 5 minutes by `deploy.sh` running on the VPS via cron. When changes are detected:

1. Workspace files (SOUL.md, AGENTS.md, USER.md, HEARTBEAT.md) are synced automatically
2. openclaw.json changes require manual review (contains placeholder syntax)
3. Skill repos are synced independently

## Setup

```bash
# On VPS, clone this repo
cd ~/.openclaw/repos
git clone git@github.com:Skitchy/claw-config.git

# Copy secrets template and fill in values
cp claw-config/.env.example ~/.openclaw/.env
nano ~/.openclaw/.env

# Make deploy script executable
chmod +x claw-config/deploy.sh

# Add to crontab
crontab -e
# Add: */5 * * * * ~/.openclaw/deploy.sh >> ~/.openclaw/deploy.log 2>&1
```

## Architecture

See `Claw-Ecosystem-Blueprint-v2.md` for the full architecture document.

**Agent structure:** Opus brain (Claw) + Sonnet/Flash hands (sub-agents)  
**Communication:** Signal  
**Infrastructure:** Hetzner VPS + Tailscale  
**Skills:** RedClaw, BlueClaw, HackerClaw, XClaw (each in their own public repo)
