---
name: xclaw
description: >
  Post tweets, read X/Twitter timelines, search X, reply to threads, quote tweet,
  and manage X/Twitter presence. Uses browser automation via the openclaw-managed
  Chrome profile. Handles drafting, confidence scoring, and audit logging for
  all autonomous X posts.
metadata:
  openclaw:
    emoji: "🐦"
---

# XClaw — X/Twitter Integration Skill

You have access to Skitch's X/Twitter account via browser automation using the openclaw-managed Chrome profile. **Do NOT use the X API** — this uses the browser tool exclusively.

## CRITICAL: Never Automate Login

X will lock the account if it detects automated login. Skitch has already logged in manually via the openclaw Chrome profile. If the session expires, notify Skitch via Signal — do NOT attempt to log in.

## Read Operations

All read operations use the `browser` tool in AI snapshot mode.

### Read Timeline
1. Open `https://x.com/home` in the openclaw browser profile
2. Use `browser snapshot` (ai mode) to read the timeline
3. Scroll and snapshot again for more content

### Search Topics
1. Navigate to `https://x.com/search?q=<query>&f=live` for real-time results
2. Use `browser snapshot` to read results
3. For hashtag research: `https://x.com/search?q=%23<hashtag>`

### Read a Profile
1. Navigate to `https://x.com/<username>`
2. Snapshot to read their recent posts

### Read a Thread
1. Navigate to the tweet URL directly
2. Snapshot to read the full thread and replies

## Write Operations

### Compose a Tweet
1. Navigate to `https://x.com/compose/tweet`
2. Use `browser act` to type the tweet text
3. Click the "Post" button

### Reply to a Tweet
1. Navigate to the tweet URL
2. Click the reply button
3. Type the reply text
4. Click "Reply"

### Quote Tweet
1. Navigate to the tweet URL
2. Click the retweet icon, then "Quote"
3. Add commentary text
4. Click "Post"

## Confidence-Based Posting Workflow

Before ANY write operation:

1. **Read KILLSWITCH.md** — if `x` is DISABLED, do not post. Log the blocked attempt to AUDIT.md.
2. **Score confidence:**
   - **High (>0.8):** Clear topic match from SOUL.md whitelist, simple share/comment, familiar community. Post directly.
   - **Medium (0.5–0.8):** Opinion piece, reply to someone new, content requiring tone judgment. Draft and send to Skitch via Signal for approval.
   - **Low (<0.5):** Controversial topic, unfamiliar context, unclear if Skitch would engage. Flag only, do NOT post.
3. **Log to AUDIT.md BEFORE posting** (even for high-confidence posts).

## Content Guidelines

- Match Skitch's voice: direct, technically curious, slightly irreverent
- 280 character limit — be punchy
- Crypto content uses CryptoSkitch persona
- Solar content uses Shop.Solar branding
- Never: politics, religion, controversies, anything that could embarrass Skitch professionally
- Always check SOUL.md topic whitelist/blacklist

## Audit Trail

Log every action to AUDIT.md using this format:
```
[YYYY-MM-DD HH:MM UTC] [X] [CONFIDENCE: 0.XX] [ACTION: tweet|reply|quote] [STATUS: posted|pending-approval|flagged] Content preview here...
```

## Rate Limits

- No more than 10 tweets per day unless Skitch approves
- Space posts at least 30 minutes apart to appear natural
- No bulk operations (mass follow/unfollow)
- Monitor for rate limit pages in browser snapshots

## Error Handling

- If browser shows a login page — session expired. Notify Skitch via Signal. Do NOT attempt login.
- If browser shows a rate limit warning — back off for 1 hour, notify Skitch.
- If a tweet fails to post — log the failure to AUDIT.md, do NOT retry automatically.
- If account appears locked/suspended — notify Skitch immediately via Signal, disable X in KILLSWITCH.md.
