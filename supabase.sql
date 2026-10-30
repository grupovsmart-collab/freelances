-- Execute no SQL Editor de um projeto Supabase novo.
create extension if not exists pgcrypto;
create table if not exists public.freelancer_people (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id),
 name text not null,
 cpf text not null,
 phone text not null default '',
 pix text not null default '',
 address text not null default '',
 status text not null default 'active' check (status in ('active','inactive')),
 created_at timestamptz not null default now(),
 unique(owner_id,cpf),
 unique(id,owner_id)
);
create table if not exists public.freelancer_marks (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id),
 person_id uuid not null,
 work_date date not null,
 shift text not null check(shift in ('M','T')),
 state text not null check(state in ('yes','no','partial')),
 start_time time,
 end_time time,
 note text not null default '',
 created_at timestamptz not null default now(),
 unique(person_id,work_date,shift),
 foreign key(person_id,owner_id) references public.freelancer_people(id,owner_id) on delete cascade,
 check (state <> 'partial' or (start_time is not null and end_time is not null and end_time > start_time))
);
create index if not exists freelancer_marks_owner_date_idx on public.freelancer_marks(owner_id,work_date);
alter table public.freelancer_people enable row level security;
alter table public.freelancer_marks enable row level security;
revoke all on public.freelancer_people from anon;
revoke all on public.freelancer_marks from anon;
grant select,insert,update,delete on public.freelancer_people to authenticated;
grant select,insert,update,delete on public.freelancer_marks to authenticated;
create policy "people_select" on public.freelancer_people for select to authenticated using (owner_id = (select auth.uid()));
create policy "people_insert" on public.freelancer_people for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "people_update" on public.freelancer_people for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy "people_delete" on public.freelancer_people for delete to authenticated using (owner_id = (select auth.uid()));
create policy "marks_select" on public.freelancer_marks for select to authenticated using (owner_id = (select auth.uid()));
create policy "marks_insert" on public.freelancer_marks for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "marks_update" on public.freelancer_marks for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy "marks_delete" on public.freelancer_marks for delete to authenticated using (owner_id = (select auth.uid()));
