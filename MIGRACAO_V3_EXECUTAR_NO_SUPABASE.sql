-- MIGRAÇÃO PARA PROJETO EXISTENTE. Execute UMA VEZ no SQL Editor do Supabase.
-- Não apaga colaboradores, presenças ou pagamentos.
begin;
alter table public.freelancer_marks drop constraint if exists freelancer_marks_shift_check;
alter table public.freelancer_marks add constraint freelancer_marks_shift_check check (shift in ('M','T','N'));
-- Permitir turno noturno encerrando às 00:00 (meia-noite do dia seguinte).
alter table public.freelancer_marks drop constraint if exists freelancer_marks_check;
alter table public.freelancer_marks add constraint freelancer_marks_check check (
 state <> 'partial' or (start_time is not null and end_time is not null and (
  (shift = 'N' and start_time >= time '18:00' and end_time = time '00:00')
  or end_time > start_time
 ))
);
create table if not exists public.freelancer_advances (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id),
 person_id uuid not null,
 paid_on date not null,
 amount_cents integer not null check (amount_cents > 0),
 note text not null default '',
 created_at timestamptz not null default now(),
 foreign key(person_id,owner_id) references public.freelancer_people(id,owner_id) on delete restrict
);
create index if not exists freelancer_advances_owner_date_idx on public.freelancer_advances(owner_id,paid_on);
alter table public.freelancer_advances enable row level security;
revoke all on public.freelancer_advances from anon;
grant select,insert,update,delete on public.freelancer_advances to authenticated;
drop policy if exists advances_select on public.freelancer_advances;
drop policy if exists advances_insert on public.freelancer_advances;
drop policy if exists advances_update on public.freelancer_advances;
drop policy if exists advances_delete on public.freelancer_advances;
create policy advances_select on public.freelancer_advances for select to authenticated using (owner_id = (select auth.uid()));
create policy advances_insert on public.freelancer_advances for insert to authenticated with check (owner_id = (select auth.uid()));
create policy advances_update on public.freelancer_advances for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy advances_delete on public.freelancer_advances for delete to authenticated using (owner_id = (select auth.uid()));
commit;
