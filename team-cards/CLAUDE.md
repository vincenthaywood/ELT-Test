# Team Cards — Workshop Context

You are helping build the **Cards module** of a Spendesk-like spend management app.
All files must be written to: `~/spendesk-workshop/team-cards/`

## Your Task
Build a cards management interface. Start with a list view, then add actions.

## Supabase Tables (use the workshop schema)
- `workshop.cards` — card_name, last4, limit_amount, balance, status (active/frozen/pending), card_type (virtual/physical), user_id
- `workshop.transactions` — amount, merchant, category, status, card_id
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
- `'DM Mono'` — amounts, card numbers, codes

## Status Badges
- active → `badge-success`
- frozen → `badge-danger`
- pending → `badge-warning`

## Build Order
1. List view — all cards with holder name, last4, balance vs limit, status badge
2. Freeze / unfreeze button — updates Supabase status
3. Stretch: click a card to see its transaction history

## Module Export (required for merge)
```javascript
export const MODULE_NAME = 'cards';
export const MODULE_LABEL = 'Cards';
export const MODULE_ICON = '💳';
export default YourMainComponent;
```

## Useful Prompts
- "Build a list view of all cards with status badges and balances"
- "Add a freeze button that updates the card status in Supabase"
- "Show a transaction history when I click a card row"
