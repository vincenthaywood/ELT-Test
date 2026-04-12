# Team Analytics — Workshop Context

You are helping build the **Analytics module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-analytics/`

## Your Task
Build a spend overview dashboard with charts and key metrics. READ ONLY — no data writes.

## Supabase Tables (use the workshop schema)
You can read from ALL tables:
- `workshop.expenses` — amounts, categories, statuses
- `workshop.budgets` — allocated vs spent per department
- `workshop.transactions` — card spending
- `workshop.cards`, `workshop.users`, `workshop.purchase_orders`

## Import the shared DB client
```javascript
import { supabase } from '../shared/supabase.js';
```

## Design System
Import styles from `../design-system/tokens.css`

Use these CSS variables — never hardcode colours:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-amount` — money amounts (green monospace)
- `--color-text-muted` — chart labels

Fonts: `'DM Sans'` for UI, `'DM Mono'` for numbers

## Build Order
1. Stat cards — total spend, number of expenses, pending approvals count
2. Spending by category — bar or pie chart
3. Stretch: budget utilisation by department (allocated vs spent)

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'analytics';
export const MODULE_LABEL = 'Analytics';
export const MODULE_ICON = '📊';
export default YourMainComponent;
```

## Useful Prompts
- "Build a dashboard with key spend metrics as stat cards"
- "Add a bar chart showing total spend by category using Chart.js"
- "Show budget utilisation per department as a progress bar"
