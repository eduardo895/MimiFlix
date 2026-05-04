create table if not exists public.library_states (
  user_id uuid primary key references auth.users (id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_library_states_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists library_states_set_updated_at on public.library_states;
create trigger library_states_set_updated_at
before update on public.library_states
for each row
execute function public.set_library_states_updated_at();

create index if not exists library_states_updated_at_idx on public.library_states (updated_at desc);
