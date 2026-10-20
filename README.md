# Asrumaa Inn website

Guest site (rooms, prices, photos, arrival guide, chat) plus an admin area (bookings, invoices, sales, expenses, remaining amount, photos, guide, rate, password). Free to run: GitHub Pages + Supabase.

## 1. Supabase (database and admin login)
1. Create a free project at supabase.com.
2. SQL Editor > New query > paste `supabase/schema.sql` > Run.
3. Authentication > Sign In / Providers: turn OFF "Allow new users to sign up" and turn OFF "Confirm email".
4. Authentication > Users > Add user: email `asrumaainn@gmail.com` and a password you choose (tick auto-confirm).
5. Project Settings > API: copy the Project URL and the `anon public` key into `config.js`.

## 2. GitHub
1. Create a repository, upload all files and folders from this folder (keep `images/`, `supabase/`).
2. Settings > Pages > deploy from the `main` branch. Your site address appears there.
3. In Supabase: Authentication > URL Configuration: set Site URL to that address (needed for the reset-password link).

## Live availability
Guests see Booked or Available for each room and it updates by itself (live, plus a refresh every 30 seconds) when the admin marks a room booked or available. If you already ran an older `schema.sql`, run just this line once: `alter publication supabase_realtime add table rooms;`

## Booking requests
Guests press Book this room, enter name, phone, dates and message. Admin sees them under Admin > Requests (a red count shows new ones). Confirm creates the booking, marks the room booked and opens the invoice. If you already ran an older `schema.sql`, run `supabase/booking_requests.sql` once.

## Admin
Open the site, press Admin, log in with username `admin` (change it in `config.js`) and your password.
- Forgot password: press "Forgot password", a link is emailed, open it and type a new password.
- Change password: Admin > Settings.
- Replace photos, add arrival-guide places, change the nightly rate, mark rooms booked.

## Notes
- Only people you create in Supabase Authentication can use admin features; sales and expenses are blocked for everyone else by the database rules.
- Room photos are visible to everyone. Prices show after a guest enters their name and contact; this is a simple step, not strong security.
- The chat uses fixed rules and answers from the live room list.
