# Team Procurement — Workshop Context

You are helping build the **Procurement module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-procurement/`

## Your Task
Build a purchase order tracker.

## Supabase Tables (use the workshop schema)
- `workshop.purchase_orders` — vendor, description, amount, category, status (draft/pending_approval/approved/ordered/received/cancelled), priority (low/medium/high/urgent), due_date, requester_id
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

## Priority Badge Colours
- urgent → `badge-danger`
- high → `badge-warning`
- medium → `badge-accent`
- low → `badge-neutral`

## Build Order
1. PO list — vendor, amount, priority badge, status badge, requester name, due date
2. Stretch: create a new PO with a simple form

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'procurement';
export const MODULE_LABEL = 'Procurement';
export const MODULE_ICON = '📦';
export default YourMainComponent;
```

## Useful Prompts
- "Build a list of purchase orders with priority and status badges"
- "Sort by due date with the most urgent at the top"
- "Add a form to create a new purchase order that saves to Supabase"
