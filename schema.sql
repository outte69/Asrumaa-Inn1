-- Run this once in Supabase: SQL Editor > New query > paste > Run
create table rooms(id int primary key, name text not null, booked boolean default false, photo text, bath_photo text);
create table bookings(id bigint generated always as identity primary key, guest text not null, room_id int references rooms(id), check_in date, nights int not null, total numeric not null, created_at timestamptz default now());
create table expenses(id bigint generated always as identity primary key, d date default current_date, description text not null, amount numeric not null);
create table settings(key text primary key, value text);
create table guide(id bigint generated always as identity primary key, title text not null, description text, image text, sort int default 0);
create table guests(id bigint generated always as identity primary key, name text, contact text, created_at timestamptz default now());
insert into rooms(id,name) values (1,'Room 1'),(2,'Room 2'),(3,'Room 3');
insert into settings values ('rate','450');

do $$ declare t text; begin
  foreach t in array array['rooms','guide','settings'] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy "public read" on %I for select using (true)', t);
    execute format('create policy "admin write" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
  foreach t in array array['bookings','expenses','guests'] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy "admin only" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;
create policy "guests can register" on guests for insert to anon with check (true);

insert into storage.buckets (id,name,public) values ('photos','photos',true) on conflict do nothing;
create policy "photos public read" on storage.objects for select using (bucket_id='photos');
create policy "photos admin insert" on storage.objects for insert to authenticated with check (bucket_id='photos');
create policy "photos admin update" on storage.objects for update to authenticated using (bucket_id='photos');
create policy "photos admin delete" on storage.objects for delete to authenticated using (bucket_id='photos');


-- Booking requests from guests
create table booking_requests(id bigint generated always as identity primary key, room_id int references rooms(id), name text not null, phone text not null, email text, check_in date not null, nights int not null, message text, status text not null default 'pending', created_at timestamptz default now());
alter table booking_requests enable row level security;
create policy "anyone can request" on booking_requests for insert to anon, authenticated with check (status = 'pending');
create policy "admin only" on booking_requests for all to authenticated using (true) with check (true);

-- Live room availability for guests
alter publication supabase_realtime add table rooms;
