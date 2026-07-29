# CBO Hiring Dashboard

Static shared hiring dashboard for a small CBO search team.

Open `index.html` directly for offline/localStorage mode. To enable shared real-time mode:

1. Create a Supabase project.
2. Run `supabase-setup.sql` in the SQL editor.
3. Add the invited users in Supabase Auth.
4. Paste the Project URL and anon public key into the config block in `index.html`.
5. Deploy the folder to Vercel.

Never paste a Supabase `service_role` key into the HTML.
