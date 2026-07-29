# CBO Hiring Dashboard — Shared (Vercel + Supabase) Setup

This turns the single-file tool into a **shared, multi-user web app**: everyone opens one URL,
logs in with their own email, and edits the **same live data**. Changes sync in real time.

> The file still works 100% offline (localStorage) until you fill in the Supabase keys.
> So nothing breaks in the meantime — you can set this up whenever you're ready.

Total time: ~20–30 minutes. No coding required beyond copy-paste.

---

## Step 1 — Create a Supabase project (free)

1. Go to https://supabase.com → **Sign in** → **New project**.
2. Name it e.g. `cbo-hiring`, pick a region close to Israel (e.g. `eu-central`), set a database password (save it), **Create**.
3. Wait ~2 min for it to provision.

## Step 2 — Create the database table (copy-paste SQL)

1. In the project, open **SQL Editor** (left sidebar) → **New query**.
2. Paste the entire contents of `supabase-setup.sql` (next to this file) and click **Run**.
3. You should see "Success". This creates the `board` table, security rules, seeds an empty board, and turns on real-time.

## Step 3 — Turn on email login + add your 4 people

1. Go to **Authentication → Providers → Email**. Make sure **Email** is **enabled**.
2. Turn **OFF** "Allow new users to sign up" (so only your invited people can get in).
3. Go to **Authentication → Users → Add user** and add each person by email (no password needed — they log in via a one-time link):
   - Shelly, Sharon, Esti, Micha (their real emails).
   - Tick "Auto Confirm User" for each.

> Because sign-ups are off, only these pre-added emails can ever log in.

## Step 4 — Get your keys and paste them into the HTML

1. Go to **Project Settings → API**.
2. Copy **Project URL** and the **anon public** key.
3. Open `cbo-hiring.html`, find the config block near the top (marked `הגדרות שיתוף`) and fill in:

   ```js
   const SUPABASE_URL  = "https://xxxxxxxx.supabase.co";   // your Project URL
   const SUPABASE_ANON = "eyJhbGciOi...";                  // your anon public key
   const BOARD_ID      = "cbo-fiverr-2026";                // leave as-is (must match the SQL seed)
   ```

   > Only ever paste the **anon public** key here — never the `service_role` key.

## Step 5 — Deploy to Vercel

Easiest (no CLI):
1. Rename `cbo-hiring.html` → `index.html`.
2. Go to https://vercel.com → sign in → **Add New → Project → Deploy** (you can drag-and-drop the folder containing `index.html`, or connect a Git repo / use `vercel` CLI).
3. Vercel gives you a URL like `https://cbo-hiring.vercel.app`.

## Step 6 — Tell Supabase about your Vercel URL (important!)

The login link needs to redirect back to your live site.
1. In Supabase → **Authentication → URL Configuration**.
2. Set **Site URL** to your Vercel URL (e.g. `https://cbo-hiring.vercel.app`).
3. Under **Redirect URLs**, add the same URL (and `https://cbo-hiring.vercel.app/**`).
4. Save.

## Step 7 — Test

1. Open the Vercel URL. You'll see the login screen.
2. Enter one of the 4 emails → **שלח לי קישור כניסה** → check that inbox → click the link → you're in.
3. Add a candidate. Open the same URL in another browser/person, log in — the candidate appears. Edits sync live.

---

## How syncing works (plain English)

- All candidate data lives in one row in Supabase (`board`), stored as JSON.
- Every save (CV, Sharon form, Esti form, extra interview, stars) pushes to Supabase automatically. You'll see a small **✔ מסונכרן** indicator under the title.
- When someone else changes something, your dashboard/compare views refresh automatically. If you happen to be *inside a candidate's form* while an update arrives, a small "🔄 עודכן מידע חדש" button appears so your typing isn't wiped — click it to refresh that candidate.
- If Supabase is ever unreachable, your work is still cached locally and the tool keeps running; it re-syncs when you save again.

## Concurrency note

The whole board is saved as one record (simplest, most reliable). Real-time sync keeps everyone
current, so in practice two people editing at the same second is very rare with a 4-person team.
If two people *do* save the exact same board within a second of each other, the last save wins.
For an exec search over a couple of weeks this is a non-issue — but flag it to me if you ever
want per-candidate-level locking and I'll add it.

## The old "share code" still works

The 📤/📥 share-code buttons are untouched, so they remain as a manual backup if anyone is offline.

## Security

- Data is protected by login — only your 4 pre-added emails can read or write.
- Row-Level Security is on; the anon key alone can't read anything without a valid login.
- This holds confidential candidate assessments, so keep the Vercel URL private and don't re-enable public sign-ups.
