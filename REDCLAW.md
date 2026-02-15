---
name: redclaw
description: "Interact with Reddit via Data API: read feed, check inbox, draft replies, submit posts for /u/Skitchy"
requires:
  env:
    - REDDIT_CLIENT_ID
    - REDDIT_CLIENT_SECRET
    - REDDIT_REFRESH_TOKEN
  bins:
    - curl
    - jq
---

# RedClaw — Reddit Integration Skill

You have access to Skitch's Reddit account (/u/Skitchy) via the Reddit Data API.

**STATUS: Pending API approval. Do not attempt API calls until credentials are configured.**

## Authentication

Reddit uses OAuth2 with refresh tokens. Access tokens expire every 60 minutes.

### Refresh the Access Token

```bash
ACCESS_TOKEN=$(curl -s -X POST https://www.reddit.com/api/v1/access_token \
  -u "$REDDIT_CLIENT_ID:$REDDIT_CLIENT_SECRET" \
  -d "grant_type=refresh_token&refresh_token=$REDDIT_REFRESH_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  | jq -r '.access_token')
```

Always include the User-Agent header on every request:
`linux:RedClaw:v0.1 (by /u/Skitchy)`

### Check Token Health

```bash
curl -s -X GET https://oauth.reddit.com/api/v1/me \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  | jq '{name, link_karma, comment_karma}'
```

## Core Operations

### Read Inbox

```bash
curl -s -X GET "https://oauth.reddit.com/message/inbox?limit=10" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  | jq '.data.children[] | {author: .data.author, subject: .data.subject, body: .data.body}'
```

### Read Subreddit Feed

```bash
curl -s -X GET "https://oauth.reddit.com/r/SUBREDDIT/hot?limit=25" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  | jq '.data.children[] | {title: .data.title, author: .data.author, score: .data.score, url: .data.url}'
```

### Submit a Comment

```bash
curl -s -X POST "https://oauth.reddit.com/api/comment" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  -d "thing_id=PARENT_FULLNAME&text=YOUR_COMMENT_TEXT"
```

### Submit a Text Post

```bash
curl -s -X POST "https://oauth.reddit.com/api/submit" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  -d "sr=SUBREDDIT&kind=self&title=POST_TITLE&text=POST_BODY"
```

### Submit a Link Post

```bash
curl -s -X POST "https://oauth.reddit.com/api/submit" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  -d "sr=SUBREDDIT&kind=link&title=POST_TITLE&url=LINK_URL"
```

### Vote

```bash
curl -s -X POST "https://oauth.reddit.com/api/vote" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  -d "id=THING_FULLNAME&dir=1"
```
dir: 1 = upvote, 0 = unvote, -1 = downvote

### Check User History

```bash
curl -s -X GET "https://oauth.reddit.com/user/Skitchy/comments?limit=10" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -A "linux:RedClaw:v0.1 (by /u/Skitchy)" \
  | jq '.data.children[] | {subreddit: .data.subreddit, body: .data.body, score: .data.score}'
```

## Target Subreddits

Primary communities for engagement:
- **Tech/coding**: r/node, r/nextjs, r/python, r/javascript
- **Solar/energy**: r/solar, r/renewableenergy
- **Art/vintage**: r/steampunk, r/vintageelectronics, r/arcade
- **General**: r/DIY, r/maker

## Guardrails

1. **/u/Skitchy is a 14-year-old account with 1 karma.** Build reputation slowly through genuine, helpful comments. Do not post aggressively.
2. Always check SOUL.md guardrails before posting.
3. Read 10x more than you post, especially in picky communities.
4. Never engage in arguments or controversial threads.
5. Focus on being helpful in tech subs first — that's where Skitch adds the most value.
6. Log every post/comment to the audit trail before submission.
7. Check the RedClaw kill switch before any write operation.

## Rate Limits

Reddit allows 100 queries per minute per OAuth client ID, averaged over 10 minutes. Monitor these response headers:
- `X-Ratelimit-Used`: Requests used in current window
- `X-Ratelimit-Remaining`: Requests remaining
- `X-Ratelimit-Reset`: Seconds until window resets

Keep well under limits. Target fewer than 30 requests per minute in practice.

## Data Retention Policy

Per Reddit's terms:
- If a user deletes their content, you must delete your copy
- If a user account is deleted, delete all author-identifying info
- Do not store Reddit content long-term — use it in-session only

## Error Handling

- 401: Token expired. Refresh and retry once.
- 403: Possible ban or scope issue. Notify Skitch immediately.
- 429: Rate limited. Back off and wait for reset.
- Never retry write operations (comments, posts) automatically.
