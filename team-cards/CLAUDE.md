# Team Cards — Workshop Context

You are helping the **Cards team** explore and rebuild part of the Spendesk product.
All files must be written to: `~/spendesk-workshop/team-cards/`

## Step 1 — Explore first, build second

Before writing any code, use Playwright to explore the Cards section of Spendesk.

Ask the user to log in to Spendesk at https://app.spendesk.com, then navigate to the **Cards** section.

Once there:
- Browse the cards list
- Click into a card to see details
- Note the key information shown: card name, holder, last 4 digits, balance, limit, status, card type
- Note any actions available: freeze, unfreeze, request card, view transactions
- Screenshot or describe what you find

Then say: **"Here’s what I found in the Cards section. Ready to build a version of this? Say yes to start."**

Do NOT start writing code until the user says yes.

## Step 2 — Build it

Once the user confirms, build the Cards module.
All files go in: `~/spendesk-workshop/team-cards/`

## Supabase Tables
Import the shared client:
```javascript
import { supabase } from '../shared/supabase.js';
```
- `workshop.cards` — card_name, last4, limit_amount, balance, status, card_type, user_id
- `workshop.transactions` — amount, merchant, category, status, card_id
- `workshop.users` — name, email, department

## Design System
Import: `../design-system/tokens.css`

Never hardcode colours — always use CSS variables:
- `--color-bg`, `--color-surface`, `--color-accent`
- `--color-success` / `--color-warning` / `--color-danger`
- `--color-amount` — money values (green monospace)

Fonts: `'DM Sans'` for UI, `'DM Mono'` for amounts and card numbers

## Status Badges
- active → `badge-success`
- frozen → `badge-danger`
- pending → `badge-warning`

## Build Order
1. Cards list — holder name, last4, balance vs limit, status badge, card type
2. Freeze / unfreeze button — updates Supabase
3. Stretch: click a card to see transaction history

## Module Export
```javascript
export const MODULE_NAME = 'cards';
export const MODULE_LABEL = 'Cards';
export const MODULE_ICON = '💳';
export default YourMainComponent;
```
