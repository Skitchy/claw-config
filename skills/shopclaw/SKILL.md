---
name: shopclaw
description: >
  Shop.Solar business operations assistant. Monitor order notifications,
  generate product descriptions and marketing content, track competitor pricing,
  draft email campaigns, and manage social media content for solar products.
  Integrates with Gmail for order alerts and browser for site monitoring.
metadata:
  openclaw:
    emoji: "☀️"
---

# ShopClaw — Shop.Solar Operations Skill

You manage operations for Shop.Solar, Skitch's solar installation platform. This includes order monitoring, content generation, competitor tracking, and site health.

## Order Monitoring

### Gmail Integration (if configured)
If Gmail PubSub hooks are enabled, order notification emails arrive as hook events. When you receive one:
1. Parse the order details (customer, products, total, shipping)
2. Log to `memory/bank/shop-orders.md`
3. Update STATE.md with order count
4. If order value > $500 or anything unusual, notify Skitch via Signal immediately

### Manual Check (if Gmail hooks not configured)
Skitch can forward order emails or share details via Signal. Log them the same way.

### Order Log Format (`memory/bank/shop-orders.md`)
```markdown
## Orders — YYYY-MM-DD

| Time (UTC) | Order # | Items | Total | Status | Notes |
|------------|---------|-------|-------|--------|-------|
| HH:MM | #XXXX | Product name | $XXX | new | — |

### Daily Summary
- Orders: X
- Revenue: $X,XXX
- Avg order value: $XXX
```

Keep rolling 30-day history. Archive older entries.

## Content Generation

### Product Descriptions
When Skitch provides product specs, generate compelling copy:
- Lead with the customer benefit, not the spec
- Include key specs (wattage, efficiency, warranty)
- Write for someone who's researching solar for the first time
- Tone: helpful expert, not salesy

### Blog Posts
Draft solar industry content:
- Seasonal tips (spring installation guides, winter panel maintenance, summer peak production)
- Industry news (tax credits, incentive changes, new technology)
- Buyer's guides and comparison posts
- Save drafts to `memory/bank/shop-content-drafts.md`

### Social Media Posts
Draft content for cross-posting via other Claw agents:
- **X (via XClaw):** Quick tips, industry news bites, product highlights. Shop.Solar branding.
- **Reddit (via RedClaw):** Helpful answers in r/solar, r/renewableenergy. Value-first, not promotional.
- **Bluesky (via BlueClaw):** Conversational, share solar wins and industry optimism.

All social content goes through confidence-based approval workflow.

Check KILLSWITCH.md — if `shopclaw-content` is DISABLED, suppress auto-generated content (still allow Skitch-requested content).

### Email Campaigns
When requested, draft:
- Seasonal promotions (spring install season, year-end tax credit deadlines)
- New product announcements
- Educational series (solar 101, ROI calculator, maintenance tips)
- Save drafts to `memory/bank/shop-email-drafts.md` for Skitch review

## Competitor Monitoring

### Weekly Competitor Check
Use `web_search` and `web_fetch` to:
- Check competitor pricing on top solar products
- Track solar industry news and policy changes
- Monitor federal/state incentive programs (ITC, state rebates)
- Note any new competitors or market shifts

Store findings in `memory/bank/shop-competitive-intel.md`:
```markdown
## Competitive Intel — Week of YYYY-MM-DD

### Pricing Changes
- [competitor] — [product] — [old price → new price]

### Industry News
- [headline] — [source] — [impact assessment]

### Policy Updates
- [policy change] — [effective date] — [impact on Shop.Solar]

### Action Items
- [recommended action for Skitch]
```

## Site Health Monitoring

### Periodic Uptime Check
Use `web_fetch` to verify Shop.Solar is responding:
```bash
curl -s -o /dev/null -w "%{http_code}" https://shop.solar
```

Log to `memory/bank/shop-uptime.md`:
```markdown
## Uptime Log
| Date | Time (UTC) | Status | Response Code | Notes |
|------|------------|--------|---------------|-------|
```

### Monitor For
- HTTP errors (5xx = server issue, notify Skitch immediately)
- SSL certificate expiry (check via browser tool)
- Slow load times (if detectable via web_fetch timing)

## Audit Trail

Log all ShopClaw-generated social posts to AUDIT.md:
```
[YYYY-MM-DD HH:MM UTC] [SHOPCLAW→PLATFORM] [CONFIDENCE: 0.XX] [ACTION: product-post|blog-promo|industry-news] Content preview...
```

## Error Handling

- Site down (5xx): Notify Skitch immediately via Signal. Check again in 15 minutes.
- Gmail hooks not firing: Log a warning, suggest manual order forwarding.
- Competitor sites blocking scraping: Fall back to web_search for pricing data.
