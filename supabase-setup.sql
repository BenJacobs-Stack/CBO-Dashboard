-- ============================================================
-- CBO Hiring Dashboard — Supabase setup
-- Run this once in Supabase → SQL Editor → New query → Run.
-- ============================================================

-- 1) Board table: one row holds the whole shared state as JSON
create table if not exists public.board (
  id          text primary key,
  data        jsonb not null default '{"candidates":[]}',
  updated_at  timestamptz not null default now()
);

-- 2) Turn on Row Level Security
alter table public.board enable row level security;

-- 3) Policies: any signed-in (authenticated) user can read + write the board
drop policy if exists "authenticated read"   on public.board;
drop policy if exists "authenticated insert" on public.board;
drop policy if exists "authenticated update" on public.board;

create policy "authenticated read" on public.board
  for select to authenticated using (true);

create policy "authenticated insert" on public.board
  for insert to authenticated with check (true);

create policy "authenticated update" on public.board
  for update to authenticated using (true) with check (true);

-- 4) Seed the initial empty board.
--    The id MUST match BOARD_ID in index.html (default: cbo-fiverr-2026)
insert into public.board (id, data)
values ('cbo-fiverr-2026', '{"candidates":[]}')
on conflict (id) do nothing;

-- 5) Enable real-time updates for the board table
alter publication supabase_realtime add table public.board;
