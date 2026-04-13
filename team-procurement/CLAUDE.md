# Team Procurement — Workshop Context

You are helping the **Procurement team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-procurement/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Purchase Orders section of Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Purchase Orders** section.

Once there:
- Browse the PO list
- Note the key information: vendor, description, amount, requester, status, priority
- Note any actions: create PO, approve, cancel
- Click into a PO to see the detail view
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Purchase Orders section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Procurement module.
All files go in: `~/spendesk-workshop/team-procurement/`

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
- `workshop.purchase_orders` — vendor, description, amount, category, status, priority, due_date, requester_id
- `workshop.users` — name, email, department

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money values

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Priority Badge Colours
- urgent → `badge-danger`
- high → `badge-warning`
- medium → `badge-accent`
- low → `badge-neutral`

## Build Order
1. PO list — vendor, amount, priority badge, status badge, requester, due date
2. Stretch: create a new PO via a form

## Module Export
```javascript
export const MODULE_NAME = 'procurement';
export const MODULE_LABEL = 'Procurement';
export const MODULE_ICON = '📦';
export default YourMainComponent;
```
