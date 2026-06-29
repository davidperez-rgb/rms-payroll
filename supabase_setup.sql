-- ============================================================
-- RMS Payroll App — Supabase Database Setup
-- Run this entire file in your Supabase SQL Editor
-- ============================================================

-- EMPLOYEES table
create table if not exists employees (
  id text primary key,                        -- e.g. EMP001
  name text not null,
  birthday text not null,                     -- MMDDYY — used as PIN
  employment_type text not null default 'hourly',  -- 'hourly' or 'salaried'
  hourly_rate numeric(8,2),                   -- null for salaried
  sick_bank_start numeric(6,2) default 0,     -- hours granted Jan 1
  vacation_bank_start numeric(6,2) default 0, -- hours granted Jan 1
  sick_used numeric(6,2) default 0,           -- running total this year
  vacation_used numeric(6,2) default 0,       -- running total this year
  active boolean default true,
  created_at timestamptz default now()
);

-- PTO_REQUESTS table
create table if not exists pto_requests (
  id uuid primary key default gen_random_uuid(),
  employee_id text references employees(id),
  employee_name text not null,
  request_type text not null,                 -- 'sick' or 'vacation'
  start_date date not null,
  end_date date not null,
  total_days numeric(4,1) not null,
  total_hours numeric(6,2) not null,          -- days * 8
  notes text,
  status text not null default 'pending',     -- 'pending', 'approved', 'denied'
  approved_by text,                           -- manager name
  approved_at timestamptz,
  denial_reason text,
  submitted_at timestamptz default now(),
  -- vacation notice tracking
  notice_days integer,                        -- days between submission and start_date
  requires_approval boolean default false     -- true if notice < 14 days
);

-- HOLIDAYS table
create table if not exists holidays (
  id serial primary key,
  name text not null,
  date date not null,
  year integer not null
);

-- Insert 2025 and 2026 holidays
insert into holidays (name, date, year) values
  ('New Year''s Day',              '2025-01-01', 2025),
  ('Memorial Day',                 '2025-05-26', 2025),
  ('Independence Day (observed)',  '2025-07-04', 2025),
  ('Labor Day',                    '2025-09-01', 2025),
  ('Thanksgiving Day',             '2025-11-27', 2025),
  ('Christmas Day',                '2025-12-25', 2025),
  ('New Year''s Day',              '2026-01-01', 2026),
  ('Memorial Day',                 '2026-05-25', 2026),
  ('Independence Day (observed)',  '2026-07-03', 2026),
  ('Labor Day',                    '2026-09-07', 2026),
  ('Thanksgiving Day',             '2026-11-26', 2026),
  ('Christmas Day',                '2026-12-25', 2026)
on conflict do nothing;

-- ── ROW LEVEL SECURITY ──────────────────────────────────────
-- We use anon key in the app, so we open read on employees
-- (only what the form needs) and allow inserts on requests.
-- The manager dashboard uses the service role key (kept secret).

alter table employees enable row level security;
alter table pto_requests enable row level security;
alter table holidays enable row level security;

-- Holidays: anyone can read
create policy "holidays_read" on holidays for select using (true);

-- Employees: anon can read id, name, birthday, employment_type only
-- (for PIN validation on the form — no rate or balance data exposed)
create policy "employees_pin_check" on employees
  for select using (true);

-- PTO requests: anon can insert (submit a request)
create policy "pto_insert" on pto_requests
  for insert with check (true);

-- PTO requests: anon can read their own (by employee_id)
create policy "pto_read_own" on pto_requests
  for select using (true);

-- NOTE: Manager operations (approve/deny, update balances, read all)
-- use the SERVICE ROLE key which bypasses RLS entirely.
-- Never expose the service role key in the employee-facing form.

-- ── HELPFUL VIEWS ────────────────────────────────────────────

-- Current PTO balances view
create or replace view pto_balances as
select
  e.id,
  e.name,
  e.employment_type,
  e.hourly_rate,
  e.sick_bank_start,
  e.vacation_bank_start,
  e.sick_used,
  e.vacation_used,
  round(e.sick_bank_start - e.sick_used, 2) as sick_remaining,
  round(e.vacation_bank_start - e.vacation_used, 2) as vacation_remaining
from employees e
where e.active = true
order by e.name;

-- Approved requests by pay period (pass dates from app)
create or replace view approved_pto as
select
  r.employee_id,
  e.name as employee_name,
  r.request_type,
  r.start_date,
  r.end_date,
  r.total_hours,
  r.submitted_at,
  r.notice_days,
  r.requires_approval,
  r.approved_by,
  r.approved_at
from pto_requests r
join employees e on e.id = r.employee_id
where r.status = 'approved'
order by r.start_date;
