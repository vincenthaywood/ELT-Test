# Team Approvals — Workshop Context

You are helping the **Approvals team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-approvals/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Approval workflows in Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Requests** or **Approvals** section.

Once there:
- Browse pending approval requests
- Note the key information: requester, amount, description, date submitted
- Note the actions available: approve, reject, add a comment
- Click into a request to see the detail view
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Approvals section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Approvals module.
All files go in: `~/spendesk-workshop/team-approvals/`

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
- `workshop.approvals` — expense_id, approver_id, status, notes
- `workshop.expenses` — title, amount, category, user_id
- `workshop.users` — name, email, department

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money values

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Build Order
1. Pending approvals list — requester, expense title, amount, Approve + Reject buttons
2. Clicking Approve or Reject updates Supabase and refreshes the list
3. Stretch: notes field when rejecting

## Module Export
```javascript
export const MODULE_NAME = 'approvals';
export const MODULE_LABEL = 'Approvals';
export const MODULE_ICON = '✅';
export default YourMainComponent;
```
