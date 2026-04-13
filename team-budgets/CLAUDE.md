# Team Budgets — Workshop Context

You are helping the **Budgets team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-budgets/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Budgets section of Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Budgets** section.

Once there:
- Browse the budget list
- Note the key information: department, period, allocated amount, amount spent, remaining
- Note any visual indicators: progress bars, colour coding for over/under budget
- Note any actions available
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Budgets section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Budgets module.
All files go in: `~/spendesk-workshop/team-budgets/`

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
- `workshop.budgets` — department_name, period, allocated_amount, spent_amount, status

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money values

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Build Order
1. Budget list — department, period, allocated vs spent, progress bar, status badge
2. Progress bar colours: green < 70%, amber 70–90%, red > 90%
3. Stretch: totals row across all departments

## Module Export
```javascript
export const MODULE_NAME = 'budgets';
export const MODULE_LABEL = 'Budgets';
export const MODULE_ICON = '💰';
export default YourMainComponent;
```
