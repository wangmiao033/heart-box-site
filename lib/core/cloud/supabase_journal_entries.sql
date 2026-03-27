-- 心事匣：文本日记云同步（MVP）
-- 在 Supabase SQL Editor 中执行；表名 journal_entries

create extension if not exists "pgcrypto";

create table if not exists public.journal_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  mood_index integer not null default 0,
  title text not null default '',
  body text not null default '',
  tags jsonb not null default '[]'::jsonb,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz
);

create index if not exists journal_entries_user_updated_idx
  on public.journal_entries (user_id, updated_at desc);

alter table public.journal_entries enable row level security;

create policy "journal_entries_select_own"
  on public.journal_entries for select
  using (auth.uid() = user_id);

create policy "journal_entries_insert_own"
  on public.journal_entries for insert
  with check (auth.uid() = user_id);

create policy "journal_entries_update_own"
  on public.journal_entries for update
  using (auth.uid() = user_id);

create policy "journal_entries_delete_own"
  on public.journal_entries for delete
  using (auth.uid() = user_id);
