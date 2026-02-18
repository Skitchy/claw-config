---
name: claw-dashboard
description: >
  Render live dashboards on Canvas using HTML/CSS/JS or A2UI components.
  Includes crypto portfolio dashboard, Shop.Solar metrics, social media
  activity feed, and system health overview. Push updates to Canvas
  on demand or during heartbeat cycles.
metadata:
  openclaw:
    emoji: "📈"
---

# Claw Dashboard — Canvas Visual Dashboard Skill

You render live dashboards on the Canvas surface. Canvas is a WebKit-based visual workspace where you push HTML/CSS/JS content for Skitch to view.

## Canvas Basics

Canvas runs on port 18793 at: `http://<gateway-host>:18793/__openclaw__/canvas/`

### Core Tools
- `canvas.eval` — Execute JavaScript in the Canvas context (push HTML, update DOM)
- `canvas.snapshot` — Take a screenshot of the current Canvas state
- `canvas.a2ui.push` — Push structured A2UI components
- `canvas.a2ui.reset` — Clear all A2UI components

## Dashboard Layout

Push a full HTML dashboard with these panels:

```html
<html>
<head>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: #0f1117;
      color: #e0e0e0;
      padding: 20px;
    }
    h1 { color: #f0f0f0; margin-bottom: 20px; font-size: 24px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .card {
      background: #1a1d27;
      border-radius: 12px;
      padding: 16px;
      border: 1px solid #2a2d37;
    }
    .card h3 { color: #8b5cf6; margin-bottom: 12px; font-size: 16px; }
    .price-up { color: #22c55e; }
    .price-down { color: #ef4444; }
    .status-ok { color: #22c55e; }
    .status-warn { color: #eab308; }
    .status-error { color: #ef4444; }
    table { width: 100%; border-collapse: collapse; font-size: 14px; }
    td, th { padding: 6px 8px; text-align: left; border-bottom: 1px solid #2a2d37; }
    th { color: #888; font-weight: normal; text-transform: uppercase; font-size: 11px; }
    .timestamp { color: #666; font-size: 12px; margin-top: 12px; }
    .activity-item { padding: 6px 0; border-bottom: 1px solid #2a2d37; font-size: 13px; }
    .activity-item:last-child { border-bottom: none; }
    .badge {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
      font-weight: bold;
    }
    .badge-x { background: #1d4ed8; }
    .badge-bluesky { background: #0369a1; }
    .badge-reddit { background: #c2410c; }
  </style>
</head>
<body>
  <h1>🦞 Claw Dashboard</h1>
  <div class="grid">
    <div class="card" id="crypto-panel">
      <h3>📊 Crypto Portfolio</h3>
      <div id="crypto-content">Loading...</div>
    </div>
    <div class="card" id="shop-panel">
      <h3>☀️ Shop.Solar</h3>
      <div id="shop-content">Loading...</div>
    </div>
    <div class="card" id="social-panel">
      <h3>🐦 Social Activity</h3>
      <div id="social-content">Loading...</div>
    </div>
    <div class="card" id="health-panel">
      <h3>🏥 System Health</h3>
      <div id="health-content">Loading...</div>
    </div>
  </div>
  <div class="timestamp" id="last-updated">Last updated: —</div>
</body>
</html>
```

## Data Sources

Pull data from these workspace files to populate panels:

| Panel | Data Source |
|-------|-----------|
| Crypto Portfolio | `memory/bank/market-data.md`, `memory/bank/portfolio.md` |
| Shop.Solar | `memory/bank/shop-orders.md`, `memory/bank/shop-uptime.md` |
| Social Activity | `AUDIT.md` (recent entries) |
| System Health | `STATE.md` (system health section) |

## Update Flow

1. Read the data source files
2. Parse the markdown tables/sections
3. Generate updated HTML for each panel
4. Push via `canvas.eval` using DOM updates (getElementById + innerHTML)
5. Update the "Last updated" timestamp

### Example Panel Update (via canvas.eval)
```javascript
document.getElementById('crypto-content').innerHTML = `
  <table>
    <tr><th>Coin</th><th>Price</th><th>24h</th><th>Value</th></tr>
    <tr><td>BTC</td><td>$97,450</td><td class="price-up">+2.3%</td><td>$48,725</td></tr>
    <tr><td>ETH</td><td>$3,180</td><td class="price-down">-1.1%</td><td>$15,900</td></tr>
  </table>
`;
document.getElementById('last-updated').textContent = 'Last updated: 2026-02-18 15:30 UTC';
```

## A2UI Interactive Components

For interactive elements (approval buttons, quick actions), use A2UI attributes:

```html
<button a2ui-action="approve-post" a2ui-param-id="pending-123">
  ✅ Approve Post
</button>
<button a2ui-action="reject-post" a2ui-param-id="pending-123">
  ❌ Reject
</button>
```

When Skitch clicks an A2UI button, it sends an action event back to Claw. Use this for:
- Approving/rejecting queued social posts
- Triggering manual market data refresh
- Toggling kill switches
- Acknowledging alerts

## Refresh Schedule

- Dashboard refreshes every 30 minutes via cron (aligned with heartbeat)
- Can be manually refreshed on demand ("Hey Claw, refresh the dashboard")
- Check KILLSWITCH.md — if `canvas-refresh` is DISABLED, skip automatic refreshes

## Error Handling

- If Canvas host is not running, skip dashboard updates silently (don't alert Skitch for this)
- If data source files are missing, show "No data yet" in the panel instead of erroring
- If canvas.eval fails, log the error and retry once on next cycle
