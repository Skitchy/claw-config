# MEMORY.md — Claw's Long-Term Memory

## Skitch — Key Facts
- Shift Operator at Weymouth Water Treatment Plant
- Runs Shop.Solar (solar installation platform) and CryptoSkitch.com (dark art, steampunk, NFTs)
- Lives in California, family roots in Alabama
- Communication: direct, no corporate speak, no fluff
- Primary contact: Signal (+12138843994)
- GitHub: Skitchy
- Skills: Python, NextJS, PostgreSQL, Tailwind CSS, vintage electronics restoration

## Active Projects
<!-- Claw updates this section as projects evolve -->
- **Shop.Solar** — Solar installation platform (active)
- **CryptoSkitch.com** — Dark art portfolio, steampunk, NFTs (active)
- **Claw Ecosystem** — This AI assistant system (active development)

## Key Decisions Log
<!-- Format: [YYYY-MM-DD] Decision — Reasoning -->
- [2026-02-16] Chose Signal as exclusive communication channel — privacy, simplicity
- [2026-02-16] Opus Brain + Cheap Hands architecture — Opus thinks, cheap models fetch
- [2026-02-17] Kimi K2.5 as sub-agent model — testing as cheaper alternative to Sonnet 4.5
- [2026-02-18] Persistence upgrade — structured STATE.md, AUDIT.md, KILLSWITCH.md for better wake-up context

## Lessons Learned
<!-- What failed, what worked, what to do differently -->
- Auth profiles must exist in BOTH agents/claw/agent/ AND agents/main/agent/
- Reddit blocks Hetzner datacenter IPs for public JSON; Devvit OAuth works fine
- signal-cli direct calls fail when gateway running — use JSON-RPC daemon at :8080
- OpenRouter does NOT support TTS — OpenAI direct only
- OPENAI_API_KEY must be in systemd service Environment block
- VPS OOMs on npm install without swap; 2GB swap added permanently
- Never edit openclaw.json without backup + openclaw doctor first

## Platform Status
<!-- Current state of each social platform integration -->
- Bluesky: cryptoskitch.bsky.social (ACTIVE — AT Protocol app password auth)
- Reddit: /u/Crypto_Skitch via Devvit OAuth (ACTIVE — token helper at /root/.openclaw/tools/reddit-token.sh)
- HackerNews: not yet built
- X/Twitter: not yet built
