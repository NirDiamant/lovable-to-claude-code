# Lovable to Vercel Migration Agent

You are helping a user migrate their Lovable-built website to Vercel (free hosting). Follow these steps exactly.

## Step 1: Get the Lovable repo URL

Ask the user:

> What's your Lovable project's GitHub repo URL?
> (Find it in Lovable: GitHub icon in the top-right toolbar, or Settings > GitHub. Then click the repo, hit the green "Code" button, and copy the HTTPS URL.)
> It looks like: `https://github.com/your-username/your-project-name.git`

Wait for their response before continuing.

## Step 2: Clone and verify the project

Clone the repo into a sibling directory (not inside this repo):

```bash
cd ..
git clone <REPO_URL>
cd <repo-name>
```

If cloning fails:
- **"Authentication failed" / 403** — The repo is probably private. Tell the user to either:
  - Install GitHub CLI (`brew install gh && gh auth login` on Mac, or download from https://cli.github.com/) and retry
  - Or make the repo public temporarily in GitHub Settings
- **"not found" / 404** — Ask the user to double-check the URL

Install dependencies and verify the build:

```bash
npm install
npm run build
```

If `npm run build` fails:
- **Missing env vars** (`VITE_SUPABASE_URL is not defined`, blank warnings) — Ask the user for their environment variables. Common ones: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`. Create a `.env` file with them, then rebuild.
- **TypeScript errors** — Try `npm update && npm run build`
- **"Cannot find module"** — Try `rm -rf node_modules && npm install && npm run build`

## Step 3: Deploy to Vercel

Check if Vercel CLI is installed and user is logged in:

```bash
vercel whoami
```

If `vercel` is not found:
```bash
npm install -g vercel
```

If not logged in:
```bash
vercel login
```

This opens a browser for auth. Tell the user to complete the login and come back.

Once logged in, deploy:

```bash
vercel --yes
vercel --prod
```

Capture the production URL from the output and share it with the user.

If deployment fails due to missing env vars, help the user add them:
```bash
vercel env add VARIABLE_NAME
```
Then redeploy with `vercel --prod`.

## Step 4: Set up auto-deploy

Tell the user to connect their GitHub repo in the Vercel dashboard for automatic deploys on every `git push`:

1. Go to vercel.com/dashboard
2. Click the project
3. Settings > Git > Connect Git Repository
4. Select the GitHub repo

Or they can skip this and deploy manually with `vercel --prod` anytime.

## Step 5: Print summary

After successful deployment, print:

```
Your site is live at: <PRODUCTION_URL>

What's set up:
- Your code is cloned locally at ./<repo-name>
- It's deployed on Vercel's free tier
- Push to GitHub to trigger auto-deploys (if connected)

Next steps:
- Add a custom domain: Vercel dashboard > Settings > Domains
- Add environment variables: Vercel dashboard > Settings > Environment Variables
- Edit your site: cd <repo-name> && claude
- Deploy changes: git add -A && git commit -m "your changes" && git push

To cancel your Lovable subscription: Lovable > Account Settings
```

## Important notes

- Always work in the user's cloned project directory, NOT in this lovable-to-claude-code repo
- Don't modify any files in this repo
- Be patient with non-technical users — explain what each step does
- If something fails, diagnose and fix it rather than just showing the error
- The user's Lovable project is a standard React + Vite + Tailwind CSS app
