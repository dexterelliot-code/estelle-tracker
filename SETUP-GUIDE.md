# Estelle's Tracker: setup guide

A private endometriosis symptom tracker that runs in Safari on iPhone and installs to the Home Screen like an app.

## What's in this folder

| File | What it is |
|---|---|
| `index.html` | The whole app (no outside libraries, no trackers) |
| `manifest.webmanifest`, `sw.js`, `icon-*.png` | Home Screen icon and offline support |
| `supabase-setup.sql` | One-time setup for the optional cloud database |
| `SETUP-GUIDE.md` | This guide |

## Part 1: Put the app online (about 10 minutes, free, done once)

The app needs a stable web address. Either option below works. The app contains no passwords or health data, so it's fine for the code itself to be public.

**Option A: GitHub Pages**
1. Sign in at github.com (or create a free account).
2. Create a new **public** repository, for example `estelle-tracker`.
3. Choose **Add file → Upload files** and drag in everything from this folder. Commit.
4. Go to **Settings → Pages**. Under "Build and deployment", choose **Deploy from a branch**, branch **main**, folder **/ (root)**. Save.
5. After a minute the address appears at the top of that page, like `https://yourname.github.io/estelle-tracker/`.

**Option B: Netlify**
1. Create a free account at netlify.com.
2. Go to **Sites** and drag this folder onto the deploy area.
3. Optionally rename the site under **Site configuration** to get an address like `https://estelle-tracker.netlify.app`.

**Keep the same address forever.** Data on the phone belongs to that exact web address. If you ever move the app, use a backup file or the cloud to bring the data across.

To update the app later, upload the new `index.html` (and `sw.js`) to the same place. Her data isn't affected.

## Part 2: Install on Estelle's iPhone

1. Open the address in **Safari** (it has to be Safari).
2. Tap **Share** (the square with an arrow), then **Add to Home Screen**, then **Add**.
3. **From now on, open it only from the Home Screen icon.** On iPhone, the Home Screen app and a Safari tab each keep a *separate* copy of their data.

Home Screen web apps aren't subject to Safari's automatic 7-day clearing of website data. Data can still be lost if the app is deleted from the Home Screen, website data is cleared in Settings, or the phone is lost. That's why Part 3 and backups matter.

## Part 3: Cloud backup and sync (strongly recommended, about 10 minutes, free)

This keeps a copy of every entry in Estelle's own private database, so her history survives a lost phone or cleared data, and she can use the app on a new phone. **It's best if Estelle creates this account herself, so she owns the data.** Whoever owns the Supabase project can see the data in its dashboard.

1. Go to **supabase.com** and sign up.
2. Click **New project**. Choose any name, set a strong database password (store it somewhere safe; the app doesn't need it), and pick the nearest region (e.g. London or Ireland). Create the project and wait for it to finish setting up.
3. Open **SQL Editor → New query**. Paste in the whole of `supabase-setup.sql` and press **Run**. It should say "Success".
4. Open **Authentication → URL Configuration** and set **Site URL** to the app's address from Part 1. Then the email confirmation link will open the app.
5. Open **Project Settings → API Keys** (or **Connect**) and copy:
   - the **Project URL** (`https://xxxx.supabase.co`)
   - the **publishable key** (starts `sb_publishable_`). If only legacy keys are shown, use the **anon / public** key.
   - **Never** use the `secret` or `service_role` key. The app refuses it.
6. In the app on her phone: **Data** tab → paste both values → **Connect**.
7. Enter her email and a password (8+ characters) → **Create account**. If Supabase sends a confirmation email, tap the link, come back to the app and tap **Sign in**.
8. The status pill should change to **Synced**. Done.
9. Optional, but sensible: back in Supabase, go to **Authentication → Sign In / Providers** and turn off **Allow new users to sign up**, so nobody else can make an account on her project.

**Free plan note:** Supabase pauses free projects after about a week with no activity. Opening the app syncs, which counts as activity. If it does pause, the app keeps saving on the phone and shows a sync warning. Sign in at supabase.com and click **Resume project**, and everything syncs again. Paused projects can be resumed for up to a year.

## Everyday use

- **Log symptoms**: the big button, or the + in the middle of the tab bar. Tap symptoms, score each 0–10 (or ? if unsure), save. There's no daily check-in.
- **No significant symptoms today**: one tap on the Overview (has Undo).
- **Edit or delete**: tap any entry in History, Overview, or a day's details. Everything can be changed later. There's also a field to add something you remembered later.
- **Bleeding and medication**: separate quick buttons on the Overview.
- **Graphs**: one date range (30 days → 1 year, or custom) drives all three graphs. Tap a point to see that day.
- **Patterns**: only shows something once there's enough data, with dates, counts and limits.

## Backups and exports (Data tab)

- **Full backup (JSON)**: the complete record. Save it to Files/iCloud Drive. A monthly backup is a good habit, even with the cloud on. The app reminds her if she has no cloud and hasn't backed up in a month.
- **Restore**: Data tab → **Choose backup file…**. It only adds or updates records, never deletes, and never replaces a newer version with an older one.
- **CSV files**: open in Excel, Numbers or Google Sheets. One row per symptom observation, plus a separate file for bleeding, medication and notes.
- **Graph images**: "Save as image" under each graph.
- **Summary for my doctor**: Graphs tab → bottom button → print screen → Share → Save to Files gives a PDF.

## Privacy

- Entries are saved on the phone first (in the app's private storage for its own web address).
- If the cloud is set up, a copy is sent over HTTPS to Estelle's own Supabase project. Database row-level security means each signed-in account can only read and change its own rows, enforced by the database itself. The publishable key in the app is designed to be public; on its own it gives no access to data.
- No analytics, ads, AI services or tracking. The app makes no network requests except to her own Supabase project.
- **Delete everything**: Data tab → Delete all my data. For complete removal, also delete the project at supabase.com.
- This app is for personal tracking and conversations with healthcare professionals. It's not a diagnostic tool and never suggests medication changes.

## How the numbers work

- A day with nothing logged is **unknown**, never zero. A symptom not mentioned on a logged day is also unknown, unless she logged "No significant symptoms" that day, which counts as 0.
- Several entries on one day are combined using the **highest** score that day, so frequent logging never inflates counts.
- Graph lines only join days next to each other. Gaps stay gaps.
- Monthly figures always show how many days were logged, so a quiet month can be told apart from an unlogged one.
- Calendar date is the only timeline. No cycle days, ovulation or PMS are assumed. Her own "suspected pattern" notes are shown as notes, not facts.
