---
name: blueclaw
description: "Interact with Bluesky via AT Protocol: post, reply, check notifications, follow accounts, and monitor feed"
requires:
  env:
    - BLUESKY_HANDLE
    - BLUESKY_APP_PASSWORD
  bins:
    - curl
    - jq
---

# BlueClaw — Bluesky Integration Skill

You have access to Skitch's Bluesky account via the AT Protocol.

## Authentication

Bluesky uses app passwords for API access. No OAuth approval needed.

To authenticate, create a session:

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.server.createSession \
  -H "Content-Type: application/json" \
  -d "{\"identifier\": \"$BLUESKY_HANDLE\", \"password\": \"$BLUESKY_APP_PASSWORD\"}" \
  | jq '.'
```

This returns an `accessJwt` and `refreshJwt`. Use the accessJwt as a Bearer token for subsequent requests. Access tokens expire after ~2 hours; use the refresh token to get a new one.

## Refreshing a Session

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.server.refreshSession \
  -H "Authorization: Bearer $REFRESH_JWT" \
  | jq '.'
```

## Core Operations

### Create a Post

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "repo": "'$BLUESKY_DID'",
    "collection": "app.bsky.feed.post",
    "record": {
      "text": "Your post text here",
      "$type": "app.bsky.feed.post",
      "createdAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"
    }
  }'
```

### Get Notifications

```bash
curl -s -X GET "https://bsky.social/xrpc/app.bsky.notification.listNotifications?limit=25" \
  -H "Authorization: Bearer $ACCESS_JWT" \
  | jq '.notifications[] | {reason, author: .author.handle, indexedAt}'
```

### Get Timeline

```bash
curl -s -X GET "https://bsky.social/xrpc/app.bsky.feed.getTimeline?limit=25" \
  -H "Authorization: Bearer $ACCESS_JWT" \
  | jq '.feed[] | {author: .post.author.handle, text: .post.record.text}'
```

### Reply to a Post

When replying, you need the parent post's URI and CID:

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "repo": "'$BLUESKY_DID'",
    "collection": "app.bsky.feed.post",
    "record": {
      "text": "Your reply text",
      "$type": "app.bsky.feed.post",
      "createdAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'",
      "reply": {
        "root": {"uri": "ORIGINAL_POST_URI", "cid": "ORIGINAL_POST_CID"},
        "parent": {"uri": "PARENT_POST_URI", "cid": "PARENT_POST_CID"}
      }
    }
  }'
```

### Like a Post

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "repo": "'$BLUESKY_DID'",
    "collection": "app.bsky.feed.like",
    "record": {
      "subject": {"uri": "POST_URI", "cid": "POST_CID"},
      "$type": "app.bsky.feed.like",
      "createdAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"
    }
  }'
```

### Follow a User

```bash
curl -s -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "repo": "'$BLUESKY_DID'",
    "collection": "app.bsky.graph.follow",
    "record": {
      "subject": "TARGET_USER_DID",
      "$type": "app.bsky.graph.follow",
      "createdAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"
    }
  }'
```

## Guardrails

Before posting, always check:
1. Does the content match the topics whitelist in SOUL.md?
2. Does it pass the "Would Skitch actually say this?" test?
3. What's the confidence level? (High → post, Medium → draft for approval, Low → flag)
4. Is the BlueClaw kill switch enabled? If disabled, do NOT post.
5. Log every post to the audit trail.

## Rate Limits

AT Protocol rate limits are generous but not unlimited. Keep requests reasonable:
- No more than 10 posts per day unless Skitch approves
- No bulk operations (mass follow/unfollow)
- Check notifications every heartbeat cycle (30 min)

## Error Handling

- If authentication fails, try refreshing the session token
- If refresh fails, the app password may have been revoked — notify Skitch
- Never retry failed posts automatically — log the failure and move on
