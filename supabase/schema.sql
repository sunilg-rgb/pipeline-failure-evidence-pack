-- Enable uuid generation
create extension if not exists "pgcrypto";

-- Evidence item type enum
do $$ begin
  create type evidence_item_type as enum ('log', 'metric', 'error', 'link', 'note');
exception
  when duplicate_object then null;
end $$;

-- evidence_items table
create table if not exists public.evidence_items (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null,
  type evidence_item_type not null,
  title text not null,
  source text,
  content text
);
