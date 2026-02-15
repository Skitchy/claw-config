# The Claw Ecosystem — Architecture Blueprint v2

## For Skitch | Designed by Claude Opus 4.6 | February 2026

---

## Philosophy

Trust is earned incrementally. Compartmentalize everything. Each capability Claw gains should be isolated, auditable, and revocable. Start with read access, graduate to draft-and-approve, then autonomous-within-guardrails — per platform, per skill, independently.

Claw's personality IS Opus. Every interaction Skitch has with Claw should feel like Opus — the voice, the reasoning, the depth, the partnership. Cheaper models do the heavy lifting behind the scenes, but Skitch never talks to anything other than Opus.

---

## Agent Architecture

### Core Principle: Opus Brain, Cheap Hands

Claw (Opus) is the personality, the decision-maker, and the only model that communicates with Skitch. Sub-agents running cheaper models handle data fetching, API calls, background polling, and routine execution. They report results back to Claw, who synthesizes and communicates.

**Critical rule:** Sub-agents fetch and format raw data. Opus analyzes and interprets. Never let a cheap model's interpretation replace Opus-level reasoning.

### Agent Roster

| Agent | Model | Role | Talks to Skitch? |
|-------|-------|------|:-:|
| **Claw** | Opus 4.6 | Personality, decisions, communication, synthesis | YES — always |
| **WorkerClaw** | Sonnet 4.5 | Mid-complexity tasks, drafting, code execution | Never |
| **PulseClaw** | Gemini Flash / cheapest available | Heartbeats, cron pings, simple data fetching | Never |

### How It Flows

```
Skitch (via Signal)
    │
    ▼
Claw (Opus 4.6) ← ONLY voice Skitch ever hears
    │
    ├── "Check my Reddit inbox"
    │     └── Spawns PulseClaw → fetch raw inbox data → return to Claw
    │           └── Claw (Opus) reads, interprets, summarizes for Skitch
    │
    ├── "Draft a blog post about my Love Doctor restoration"
    │     └── Spawns WorkerClaw → generate first draft → return to Claw
    │           └── Claw (Opus) reviews, refines, presents to Skitch
    │
    ├── "What should I post on Bluesky today?"
    │     └── Claw (Opus) thinks about this directly — strategy needs depth
    │
    ├── "Good morning, what did I miss?"
    │     └── Spawns PulseClaw → fetch all platform updates → return raw data
    │           └── Claw (Opus) synthesizes into a morning briefing
    │
    └── Background cron (every 30 min)
          └── PulseClaw handles independently
                └── Only escalates to Claw if something needs attention
```

### Cost Control Strategies

**Strategy 1: Delegate execution, keep the brain.**
Opus decides WHAT to do. Cheap models do IT. Opus tells Skitch WHAT HAPPENED. This means Opus only processes the conclusions, not the raw firehose of data.

**Strategy 2: Cap output tokens on Opus.**
Configure maxTokens per agent to keep Opus concise. Same personality, same depth — just more precise. Forces good communication habits.

**Strategy 3: Cron and heartbeats on the cheapest model.**
Background pings every 30 minutes, health checks, scheduled polling — none of this needs intelligence. Route to Gemini Flash or equivalent at fractions of a penny.

**Strategy 4: Raw data up, interpretation at the top.**
Sub-agents return raw JSON, raw text, raw data. Never let a cheap model summarize or interpret before Opus sees it. This prevents competence bleed-through where a lesser model misses nuance.

---

## Priority 1: Social Media Management

### The Guardrails (CRITICAL — design these first)

Since Claw will post autonomously, the guardrails ARE the product.

**Identity Rules:**
- Claw posts AS Skitch, never as himself or a bot (unless platform rules require disclosure)
- Tone: direct, plain-spoken, technically curious, slightly irreverent — sounds like a real person because it's representing one
- Never posts about: politics, religion, other people's personal business, anything Skitch hasn't explicitly greenlighted as a topic

**Content Rules:**
- Topics whitelist: coding/tech, solar energy, vintage electronics/restoration, art, steampunk, water treatment (if relevant), crypto/NFTs, maker culture
- No hot takes on trending controversies
- No engagement bait, no "what do you think?" farming
- Max posting frequency per platform (prevents spam perception)
- Every post must pass a "would Skitch actually say this?" test

**Safety Rails:**
- Log every post to a dedicated channel/file before it goes live (audit trail)
- "Kill switch" config flag per platform — one toggle disables all posting
- Daily summary sent to Skitch via Signal: "here's what I posted today"
- Escalation: if Claw is unsure about a post, draft it and send to Skitch for approval instead of posting

### Confidence-Based Posting Workflow (All Platforms)

```
Claw identifies something worth posting about
    │
    ├─ High confidence (clear topic match, simple share/comment)
    │   └─ Post directly → Log to audit → Include in daily summary
    │
    ├─ Medium confidence (opinion piece, reply to someone)
    │   └─ Draft → Send to Skitch via Signal → Post if approved
    │
    └─ Low confidence (controversial, unfamiliar, unclear tone)
        └─ Draft → Flag for review → Do NOT post until Skitch says go
```

### Platform Skills

#### RedClaw (Reddit) — PENDING API APPROVAL
- **Account:** /u/Skitchy (14-year-old account)
- **Repo:** github.com/[username]/RedClaw (public)
- **Capabilities:** Read feed, check inbox, draft replies, submit posts
- **Subreddits:** r/node, r/nextjs, r/python, r/javascript, r/solar, art/vintage/steampunk communities
- **Auth:** OAuth2 authorization code grant, refresh token on VPS
- **Execution model:** PulseClaw fetches data, Claw (Opus) decides what to post

#### BlueClaw (Bluesky) — FASTEST TO DEPLOY
- **Capabilities:** Post, reply, follow relevant accounts, monitor feed
- **Auth:** AT Protocol app passwords — no approval needed
- **Repo:** github.com/[username]/BlueClaw (public)
- **Notes:** Can go live this week. Best candidate for first social skill.

#### HackerClaw (Hacker News)
- **Capabilities:** Monitor front page and specific topics, submit stories, post comments
- **Auth:** Cookie-based (username/password), no OAuth
- **Repo:** github.com/[username]/HackerClaw (public)
- **Notes:** HN community is picky about bot behavior. Quality over quantity. Claw should read 10x more than he posts here.

#### XClaw (X / Twitter)
- **Capabilities:** Post tweets, reply, monitor mentions and hashtags
- **Auth:** X API OAuth 2.0 with PKCE — requires developer account approval
- **Repo:** github.com/[username]/XClaw (public)
- **Notes:** X's API pricing has changed significantly. Evaluate current tier structure before building.

---

## Priority 2: Project Monitoring

### GitHub Integration
- **Service account:** ipsoclaw@claw-service-acct.iam.gserviceaccount.com
- **Capabilities:** Monitor repos (Fortress-System, RedClaw, Shop.Solar, CryptoSkitch), track issues, review PRs, notify Skitch of activity
- **Execution:** PulseClaw polls for changes, Claw (Opus) summarizes what matters
- **Autonomy:** Read-only monitoring + notifications. No autonomous commits.

### Google Analytics
- **Access:** Via service account
- **Capabilities:** Pull traffic reports for Shop.Solar and CryptoSkitch.com, summarize trends, flag anomalies
- **Execution:** PulseClaw fetches data, Claw (Opus) analyzes and reports
- **Autonomy:** Read-only. Reports on schedule or on request.

---

## Priority 3: Shop.Solar Operations

- **Status:** Future phase
- **Potential:** Monitor leads, draft outreach emails (CAN-SPAM compliant), track campaigns
- **Autonomy:** Draft-and-approve initially. Business-facing — mistakes cost money.
- **Model:** Claw (Opus) handles all customer-facing writing. Sub-agents do data gathering.

---

## Priority 4: CryptoSkitch.com Content

- **Status:** Future phase
- **Potential:** Draft blog posts about restorations, social content for art pieces, NFT listing management
- **Autonomy:** Draft-and-approve. Creative work benefits from Skitch's personal touch.
- **Model:** Claw (Opus) for writing. Sub-agents for scheduling and posting.

---

## Priority 5: Communication (IpsoClaw Email)

- **Email:** IpsoClaw@gmail.com
- **Purpose:** Claw's own identity for services. NOT for impersonating Skitch.
- **Capabilities:** Receive service notifications, send automated reports, handle service-to-service comms
- **Autonomy:** Read all incoming. Draft outgoing for approval. Never email humans autonomously.

---

## Infrastructure

### Repos (GitOps)

| Repo | Visibility | Contents |
|------|-----------|----------|
| **claw-config** | Private | openclaw.json template, deploy scripts, agent configs, SOUL.md, guardrails |
| **RedClaw** | Public | Reddit skill + OAuth helpers |
| **BlueClaw** | Public | Bluesky skill |
| **HackerClaw** | Public | Hacker News skill |
| **XClaw** | Public | X/Twitter skill |

### VPS Layout (Hetzner, accessed via Tailscale)

```
~/.openclaw/
├── openclaw.json              ← from claw-config repo (secrets injected from .env)
├── .env                       ← ALL secrets live here, NEVER in any repo
│
├── workspace/                 ← Claw (Opus) main workspace
│   ├── skills/
│   │   ├── redclaw/           ← from RedClaw repo
│   │   ├── blueclaw/          ← from BlueClaw repo
│   │   ├── hackerclaw/        ← from HackerClaw repo
│   │   └── xclaw/             ← from XClaw repo
│   ├── SOUL.md                ← Claw's personality and guardrails
│   ├── AGENTS.md              ← Agent behavior rules
│   └── USER.md                ← Info about Skitch
│
├── agents/
│   ├── claw/                  ← Opus agent (main, personality)
│   │   └── agent/
│   │       └── auth-profiles.json
│   ├── workerclaw/            ← Sonnet agent (mid-tier tasks)
│   │   └── workspace/
│   └── pulseclaw/             ← Flash agent (background/cron)
│       └── workspace/
│
├── credentials/
│   └── signal/                ← Signal linked device
│
└── extensions/
    └── reddit-devvit/         ← ⚠️ DELETE THIS IMMEDIATELY
```

### Deploy Flow (per skill repo)

```
Skitch pushes commit to GitHub
    │  (cron checks every 5 minutes)
    ▼
VPS: git fetch → changes detected? → git pull
    │
    ▼
Skill files copied to Claw's workspace/skills/
    │
    ▼
OpenClaw skill watcher detects SKILL.md change
    │
    ▼
Claw picks up updated skill on next turn
```

---

## Credentials Map

| Service | Credential Type | Storage |
|---------|----------------|---------|
| Reddit (/u/Skitchy) | OAuth2 refresh token | VPS .env |
| Bluesky | App password | VPS .env |
| Hacker News | Username/password | VPS .env |
| X / Twitter | OAuth2 tokens | VPS .env |
| GitHub | Service account key | VPS .env |
| Google Analytics | Service account JSON | VPS (file, path in .env) |
| Gmail (IpsoClaw) | OAuth2 or app password | VPS .env |
| Anthropic API | API key | VPS .env |
| Signal | Linked device | VPS credentials dir |

---

## Immediate Action Items

1. ☐ Sort out Reddit accounts — confirm /u/Skitchy login
2. ☐ Submit Reddit API application (answers ready)
3. ☐ Create RedClaw public repo on GitHub (README ready)
4. ☐ Create claw-config private repo on GitHub
5. ☐ SSH into VPS → delete ~/.openclaw/extensions/reddit-devvit/
6. ☐ Design multi-agent openclaw.json config (Claw/WorkerClaw/PulseClaw)
7. ☐ Write SOUL.md with personality + social guardrails
8. ☐ Set up cron-based deploy pipeline on VPS
9. ☐ Build BlueClaw skill (fastest path to live — no approval needed)
10. ☐ Build RedClaw skill (once API approved, ~7 days)

---

*"Additional work or complexity is rarely an excuse for being unsafe."*
*— Skitch, 2026*
