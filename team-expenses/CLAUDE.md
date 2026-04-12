# Team Expenses — Workshop Context

You are helping build the **Expenses module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-expenses/`

## Your Task
Build an expense submission and tracking interface.

## Supabase Tables (use the workshop schema)
- `workshop.expenses` — title, amount, category, status (draft/submitted/approved/rejected/paid), user_id, description
- `workshop.users` — name, email, department

## Import the shared DB client
```javascript
import { supabase } from '../shared/supabase.js';
```

## Design System
Import styles from `../design-system/tokens.css`

Use these CSS variables — never hardcode colours:
- `--color-bg` — page background
- `--color-surface` — cards/panels
- `--color-accent` — buttons, highlights
- `--color-text` — primary text
- `--color-text-muted` — labels
- `--color-success` / `--color-warning` / `--color-danger` — status colours
- `--color-amount` — money amounts (green monospace)

Fonts:
- `'DM Sans'` — all UI text
- `'DM Mono'` — amounts

## Status Badges
- approved / paid → `badge-success`
- submitted → `badge-warning`
- rejected → `badge-danger`
- draft → `badge-neutral`

## Build Order
1. List view — all expenses with submitter name, amount, category, status badge
2. Summary bar at top — total submitted, total approved, total value
3. Stretch: submit a new expense (form that inserts to Supabase)

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'expenses';
export const MODULE_LABEL = 'Expenses';
export const MODULE_ICON = '🧾';
export default YourMainComponent;
```

## Useful Prompts
- "Build a list view of all expenses with status badges and submitter names"
- "Add a stats bar showing total count and total value by status"
- "Add a form to submit a new expense that saves to Supabase"
