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
-- Enable uuid generation
create extension if not exists "pgcrypto";

-- 1) ENUM for evidence item type (because your screenshot shows USER-DEFINED)
do $$ begin
  create type public.evidence_item_type as enum ('log', 'metric', 'error', 'link', 'note');
exception
  when duplicate_object then null;
end $$;

-- 2) evidence_packs table
create table if not exists public.evidence_packs (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null,
  summary text,
  timeline jsonb default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- This matches the error you saw:
-- "duplicate key value violates unique constraint evidence_packs_run_id_key"
create unique index if not exists evidence_packs_run_id_key
  on public.evidence_packs (run_id);

-- 3) evidence_items table (with all columns from your screenshot)
create table if not exists public.evidence_items (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null,
  type public.evidence_item_type not null,
  title text not null,
  source text,
  content text,
  content_json jsonb,
  uri text,
  created_at timestamptz not null default now()
);

-- Link evidence_items to evidence_packs by run_id
-- (this makes joins easy and prevents orphan evidence items)
alter table public.evidence_items
  add constraint evidence_items_run_id_fkey
  foreign key (run_id)
  references public.evidence_packs (run_id)
  on delete cascade;

-- Helpful index for querying by run_id fast
create index if not exists evidence_items_run_id_idx
  on public.evidence_items (run_id);
