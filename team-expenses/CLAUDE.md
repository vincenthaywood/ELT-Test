# Team Expenses — Workshop Context

You are helping the **Expenses team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-expenses/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Expenses section of Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Expense Claims** section.

Once there:
- Browse the expenses list
- Note the key information shown: title, amount, category, submitter, date, status
- Click into an expense to see the detail view
- Note any actions: submit, approve, reject, add receipt
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Expenses section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Expenses module.
All files go in: `~/spendesk-workshop/team-expenses/`

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
- `workshop.expenses` — title, amount, category, status, user_id, description
- `workshop.users` — name, email, department

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money values

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Status Badges
- approved / paid → `badge-success`
- submitted → `badge-warning`
- rejected → `badge-danger`
- draft → `badge-neutral`

## Build Order
1. Expenses list — submitter, title, amount, category, status badge
2. Stats bar — total count and value by status
3. Stretch: submit a new expense via a form

## Module Export
```javascript
export const MODULE_NAME = 'expenses';
export const MODULE_LABEL = 'Expenses';
export const MODULE_ICON = '🧾';
export default YourMainComponent;
```
