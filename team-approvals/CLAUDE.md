# Team Approvals — Workshop Context

You are helping build the **Approvals module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-approvals/`

## Your Task
Build an approval queue where managers can approve or reject expenses.

## Supabase Tables (use the workshop schema)
- `workshop.approvals` — expense_id, approver_id, status (pending/approved/rejected), notes
- `workshop.expenses` — title, amount, category, user_id
- `workshop.users` — name, email, department

## Import the shared DB client
```javascript
import { supabase } from '../shared/supabase.js';
```

## Design System
Import styles from `../design-system/tokens.css`

Use these CSS variables — never hardcode colours:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money amounts

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Build Order
1. Pending approvals list — expense title, amount, submitter, Approve + Reject buttons
2. Approve/Reject updates Supabase approval status
3. Stretch: add a notes field when rejecting

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'approvals';
export const MODULE_LABEL = 'Approvals';
export const MODULE_ICON = '✅';
export default YourMainComponent;
```

## Useful Prompts
- "Show a list of pending approvals with Approve and Reject buttons"
- "When Approve is clicked, update the status in Supabase and refresh the list"
- "Add a notes input that appears when Reject is clicked"
