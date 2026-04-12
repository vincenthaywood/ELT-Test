# CLAUDE.md — Spendesk Rebuild Workshop
> Read this first. Claude Code loads it automatically at session start.

---

## 🎯 What We're Building

You are part of a team rebuilding a core module of the Spendesk spend management platform.
Each team owns one module. All modules merge into a single app at the end of the session.

**Your job**: Build your module so it looks and feels like it belongs in the same product as everyone else's.
**The secret**: Follow this file exactly and the merge will be seamless.

---

## 🗂️ Repo Structure

```
ELT-Test/
├── CLAUDE.md                ← You are here
├── design-system/
│   └── tokens.css           ← Shared styles — import this, DO NOT modify
├── shared/
│   ├── supabase.js          ← DB client — import this, never create your own
│   ├── mock-data.json       ← Fallback data if DB is unavailable
│   └── auth.js              ← Mock auth — use this for current user context
├── team-cards/              ← Team 1
├── team-expenses/           ← Team 2
├── team-approvals/          ← Team 3
├── team-analytics/          ← Team 4
├── team-budgets/            ← Team 5
├── team-procurement/        ← Team 6
└── merged-app/              ← DO NOT TOUCH — overseeing agent writes here
```

---

## 🎨 Design System — FOLLOW EXACTLY

### Fonts
```css
font-family: 'DM Sans', sans-serif;    /* Body, labels, UI */
font-family: 'DM Mono', monospace;     /* Numbers, amounts, codes */
```

### Colour Tokens — use variables, never raw hex
```css
--color-bg:           #0F1117;
--color-surface:      #1A1D27;
--color-surface-2:    #22263A;
--color-border:       #2E3348;
--color-text:         #F0F2FF;
--color-text-muted:   #8B91A8;
--color-accent:       #4F6EF7;
--color-accent-soft:  #1E2A5E;
--color-success:      #2ECC71;
--color-warning:      #F39C12;
--color-danger:       #E74C3C;
--color-amount:       #A8F5A0;
```

### Spacing
```css
--space-1:4px; --space-2:8px; --space-3:12px;
--space-4:16px; --space-5:24px; --space-6:32px;
```

### Radius & Shadows
```css
--radius-sm:6px; --radius-md:10px; --radius-lg:16px;
--shadow-card:0 2px 12px rgba(0,0,0,0.3);
```

---

## 🧱 Component Patterns

### Page wrapper (required on every page)
```html
<div class="page-wrapper">
  <main class="main-content">
    <header class="page-header">
      <h1 class="page-title">Module Name</h1>
    </header>
    <div class="page-body"><!-- your content --></div>
  </main>
</div>
```

### Cards
```html
<div class="card">
  <div class="card-header"><span class="card-title">Title</span></div>
  <div class="card-body">...</div>
</div>
```

### Buttons
```html
<button class="btn btn-primary">Approve</button>
<button class="btn btn-secondary">Cancel</button>
<button class="btn btn-danger">Reject</button>
```

### Status badges
```html
<span class="badge badge-success">Approved</span>
<span class="badge badge-warning">Pending</span>
<span class="badge badge-danger">Rejected</span>
<span class="badge badge-neutral">Draft</span>
```

### Amounts (always DM Mono + --color-amount)
```html
<span class="amount">€2,450.00</span>
```

---

## 🗄️ Database — Supabase

**Always import the shared client. Never create your own connection.**
```javascript
import { supabase } from '../shared/supabase.js';
```

### Tables

| Table | Key Columns |
|---|---|
| `users` | id, name, email, department, role |
| `expenses` | id, user_id, amount, category, status |
| `cards` | id, user_id, limit_amount, balance, status, last4 |
| `approvals` | id, expense_id, approver_id, status, notes |
| `budgets` | id, department_name, allocated_amount, spent_amount |
| `transactions` | id, card_id, amount, merchant, status |
| `purchase_orders` | id, vendor, amount, status, priority |

### Team → Tables
- **Team Cards** → `cards`, `transactions`
- **Team Expenses** → `expenses`, `users`
- **Team Approvals** → `approvals`, `expenses`, `users`
- **Team Analytics** → READ all tables (no writes)
- **Team Budgets** → `budgets`
- **Team Procurement** → `purchase_orders`, `users`

---

## 📦 Module Export (required for merge)

Your `index.js` must export:
```javascript
export const MODULE_NAME = 'expenses';     // lowercase, no spaces
export const MODULE_LABEL = 'Expenses';    // display name
export const MODULE_ICON = '🧾';          // emoji icon
export default YourMainComponent;
```

---

## 🚫 Out of Scope — Don't Build These
- Real payment processing
- Real authentication (use `shared/auth.js`)
- Email sending
- PDF generation

---

## 💡 Workshop Prompts

**First prompt of the session:**
> "Read the CLAUDE.md and tell me what my team is building and what tables I have access to."

**To plan before building:**
> "/plan Build the [Cards] module. List view first, showing all cards with status badges and balances."

**To add a feature:**
> "Add a button to freeze a card. On click, update the status in Supabase and show a success message."

**If something looks wrong:**
> "Check the design tokens in CLAUDE.md and fix any hardcoded colours."

**If you're stuck:**
> "Revert the last change and try again with a simpler approach."

---

## ✅ Definition of Done

- [ ] Reads real data from Supabase (shared client)
- [ ] Uses CSS variables (no hardcoded colours)
- [ ] Uses DM Sans / DM Mono fonts
- [ ] Status badges colour-coded correctly
- [ ] Amounts in DM Mono with € symbol
- [ ] Standard page layout wrapper used
- [ ] `index.js` has required exports
- [ ] Works when Supabase returns empty data

---

*Workshop facilitated by Vincent Haywood · Spendesk AI Operations · May 2026*
