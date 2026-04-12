# Team Budgets — Workshop Context

You are helping build the **Budgets module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-budgets/`

## Your Task
Build a department budget tracker showing allocated vs spent amounts.

## Supabase Tables (use the workshop schema)
- `workshop.budgets` — department_name, period, allocated_amount, spent_amount, status (active/overspent/closed)

## Import the shared DB client
```javascript
import { supabase } from '../shared/supabase.js';
```

## Design System
Import styles from `../design-system/tokens.css`

Use these CSS variables — never hardcode colours:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger` — for budget health
- `--color-amount` — money amounts

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts

## Build Order
1. Budget list — department, period, allocated vs spent, progress bar, status badge
2. Progress bar colours: green < 70%, amber 70-90%, red > 90%
3. Stretch: summary row showing total across all departments

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'budgets';
export const MODULE_LABEL = 'Budgets';
export const MODULE_ICON = '💰';
export default YourMainComponent;
```

## Useful Prompts
- "Show all department budgets with a progress bar for spend vs allocation"
- "Colour the progress bar green/amber/red based on utilisation percentage"
- "Add a summary row at the bottom with totals across all departments"
