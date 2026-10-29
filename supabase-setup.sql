-- Estelle's tracker: cloud table setup for Supabase.
-- Paste this whole file into Supabase > SQL Editor > New query, then press Run.
-- It is safe to run more than once.

create table if not exists public.records (
  id          uuid primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  kind        text not null,
  data        jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  deleted     boolean not null default false
);

create index if not exists records_user_updated on public.records (user_id, updated_at);

-- Row Level Security: each signed-in person can only ever see and change their own rows.
alter table public.records enable row level security;

drop policy if exists "read own records"   on public.records;
drop policy if exists "insert own records" on public.records;
drop policy if exists "update own records" on public.records;
drop policy if exists "delete own records" on public.records;

create policy "read own records"   on public.records for select to authenticated using ((select auth.uid()) = user_id);
create policy "insert own records" on public.records for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "update own records" on public.records for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "delete own records" on public.records for delete to authenticated using ((select auth.uid()) = user_id);

-- Never let an older copy of a record overwrite a newer one (protects against
-- silent overwrites if two devices edit the same entry).
create or replace function public.records_keep_newest()
returns trigger language plpgsql as $$
begin
  if new.updated_at < old.updated_at then
    return null;  -- skip this update, keep the newer row
  end if;
  return new;
end;
$$;

drop trigger if exists records_keep_newest on public.records;
create trigger records_keep_newest
  before update on public.records
  for each row execute function public.records_keep_newest();
