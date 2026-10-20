-- Only for projects that already ran an older schema.sql
create table booking_requests(id bigint generated always as identity primary key, room_id int references rooms(id), name text not null, phone text not null, email text, check_in date not null, nights int not null, message text, status text not null default 'pending', created_at timestamptz default now());
alter table booking_requests enable row level security;
create policy "anyone can request" on booking_requests for insert to anon, authenticated with check (status = 'pending');
create policy "admin only" on booking_requests for all to authenticated using (true) with check (true);
