# Team Analytics — Workshop Context

You are helping the **Analytics team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-analytics/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Analytics / Dashboard section of Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Analytics** or **Dashboard** section.

Once there:
- Note the key metrics shown: total spend, number of transactions, budget utilisation
- Note any charts or visualisations: spending by category, trends over time
- Note any filters: date range, department, team
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Analytics section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Analytics module.
All files go in: `~/spendesk-workshop/team-analytics/`

This module is READ ONLY — no writes to Supabase.

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
You can read from ALL tables: expenses, cards, transactions, budgets, purchase_orders, users.

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-amount` — money values
- `--color-text-muted` — chart labels

Fonts: `'DM Sans'` for UI, `'DM Mono'` for numbers

## Build Order
1. Stat cards — total spend, number of expenses, pending approvals
2. Spending by category — bar or pie chart
3. Stretch: budget utilisation per department as progress bars

## Module Export
```javascript
export const MODULE_NAME = 'analytics';
export const MODULE_LABEL = 'Analytics';
export const MODULE_ICON = '📊';
export default YourMainComponent;
```
