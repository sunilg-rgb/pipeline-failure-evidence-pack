# Pipeline Failure Evidence Pack

## What this is
Demo showing how pipeline failure signals can be captured via n8n webhook and stored in Supabase, then viewed in a Next.js UI.

## Architecture
Webhook (n8n) → transform → Supabase insert → Next.js UI fetch + table display

## Setup
1. Create a Supabase project
2. Run `supabase/schema.sql` in Supabase SQL Editor
3. Add env vars to Next.js:

NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...

4. Run app:
npm install
npm run dev

## n8n
Workflow export is in `n8n/workflow.json`
