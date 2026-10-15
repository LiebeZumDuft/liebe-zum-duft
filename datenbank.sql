-- Im Supabase SQL Editor ausführen.
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.perfume_stock (
  perfume_name text not null,
  size_ml integer not null check (size_ml in (30, 50, 100)),
  quantity integer not null check (quantity >= 0),
  updated_at timestamptz not null default now(),
  primary key (perfume_name, size_ml)
);
create or replace function public.set_perfume_stock_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
drop trigger if exists trg_perfume_stock_updated_at on public.perfume_stock;
create trigger trg_perfume_stock_updated_at before update on public.perfume_stock
for each row execute function public.set_perfume_stock_updated_at();
alter table public.admin_users enable row level security;
alter table public.perfume_stock enable row level security;
-- Nur eigenes Admin-Konto ist lesbar. Neue Berechtigungen vergibt ausschließlich der Datenbankadministrator.
drop policy if exists "admins can read own membership" on public.admin_users;
create policy "admins can read own membership" on public.admin_users
for select to authenticated using ((select auth.uid()) = user_id);
-- Kunden können nur Bestände lesen; kein Schreiben möglich.
drop policy if exists "public can read stock" on public.perfume_stock;
create policy "public can read stock" on public.perfume_stock
for select to anon, authenticated using (true);
drop policy if exists "admins can insert stock" on public.perfume_stock;
create policy "admins can insert stock" on public.perfume_stock
for insert to authenticated with check (exists (
 select 1 from public.admin_users where user_id = (select auth.uid())
));
drop policy if exists "admins can update stock" on public.perfume_stock;
create policy "admins can update stock" on public.perfume_stock
for update to authenticated using (exists (
 select 1 from public.admin_users where user_id = (select auth.uid())
)) with check (exists (
 select 1 from public.admin_users where user_id = (select auth.uid())
));
-- Kein Löschrecht für Browser-Admins nötig.
grant select on public.perfume_stock to anon;
grant select, insert, update on public.perfume_stock to authenticated;
grant select on public.admin_users to authenticated;
