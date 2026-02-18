# Self-Host Your Lovable Project for Free

A step-by-step guide to hosting your Lovable-built website on Vercel (free) and editing it locally with any AI code editor.

<video src="https://github.com/NirDiamant/lovable-to-claude-code/raw/main/lovable-migration.mp4" autoplay loop muted playsinline width="100%"></video>

> **Disclaimer:** This guide helps you self-host code that you own. Lovable is a great product for building websites with AI. Lovable stores your project in a GitHub repository under your account, and their [documentation](https://docs.lovable.dev/) confirms you own your code. This guide simply shows how to deploy that code to a different host. All trademarks belong to their respective owners. This project is not affiliated with, endorsed by, or sponsored by Lovable, Vercel, or Anthropic.

---

## Who Is This For?

You built a website with Lovable. It's working great. But now you mainly just need hosting and occasional edits, and you'd rather self-host for free.

**This guide walks you through it.** No technical experience required.

**What you keep:** Your exact same website, auto-deploys, custom domain, everything.

**Time:** ~15 minutes

---

## How It Works

Lovable gives you a lot of value in one package: AI code generation, hosting, and auto-deploys. This guide shows how to use free alternatives for hosting and deployment if that suits your needs better:

| What | Lovable | Self-Hosted (This Guide) |
|------|---------|-------------------------|
| AI code generation | Built-in browser editor | Any AI code editor (Claude Code, Cursor, etc.) |
| Hosting | Lovable servers | Vercel free tier |
| Auto-deploy | On save | On git push |

> **Note:** Lovable is still the easiest way to *build* a website from scratch with AI. This guide is for after you've already built your site and want to take over hosting.

---

## Prerequisites

- A Lovable account with a project you want to self-host
- [Node.js](https://nodejs.org/) installed (v18+). Download and run the installer if you don't have it
- [Git](https://git-scm.com/downloads) installed. Most Macs already have it; Windows users download from the link
- A [GitHub](https://github.com/) account (Lovable already connected one for you)
- A [Vercel](https://vercel.com/) account (free, sign up with your GitHub account)

> **Windows users:** Use **Git Bash** for all terminal commands in this guide. It comes bundled with [Git for Windows](https://git-scm.com/downloads) — just search "Git Bash" in your Start menu after installing Git. PowerShell and CMD won't work with the migration script.

**Optional:**
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) installed (for AI-powered editing after migration)

---

## Step 1: Find Your GitHub Repo

Lovable stores your project code in a GitHub repository under your account.

1. Open your Lovable project
2. Click the **GitHub** icon in the top-right toolbar (or go to Settings > GitHub)
3. You'll see a repo name like `your-username/your-project-name`
4. Click it to open the repo on GitHub
5. Copy the repo URL (the green **Code** button > HTTPS URL)

It will look like: `https://github.com/your-username/your-project-name.git`

> **Don't see a GitHub repo?** Lovable creates one automatically when you first deploy. If yours doesn't have one, click "Connect to GitHub" in Lovable settings first.

---

## Step 2: Clone It to Your Computer

Open a terminal (Mac: Terminal app, Windows: **Git Bash**) and run:

```bash
git clone https://github.com/your-username/your-project-name.git
cd your-project-name
```

Replace `your-username/your-project-name` with your actual repo from Step 1.

> **Getting an authentication error?** If your repo is private, you need to authenticate with GitHub:
>
> - **Easiest:** Install [GitHub CLI](https://cli.github.com/) and run `gh auth login`, then try cloning again
> - **HTTPS with token:** Create a [Personal Access Token](https://github.com/settings/tokens) and use `https://YOUR_TOKEN@github.com/your-username/your-project.git`
> - **SSH:** Set up an [SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) and use `git@github.com:your-username/your-project.git`

---

## Step 3: Install Dependencies and Test Locally

```bash
npm install
npm run dev
```

Open `http://localhost:5173` (or whatever URL the terminal shows) in your browser. You should see your site exactly as it looks on Lovable.

> **Troubleshooting:** If `npm install` fails, make sure Node.js v18+ is installed (`node --version` to check). If `npm run dev` fails, try `npx vite` instead.

Press `Ctrl+C` in the terminal to stop the local server when you're done checking.

---

## Step 4: Deploy to Vercel (Free)

### Option A: Using the Vercel Dashboard (Easier)

1. Go to [vercel.com/new](https://vercel.com/new)
2. Click **"Import Git Repository"**
3. Select your GitHub account and find your project repo
4. Click **Import**
5. Leave all settings as default (Vercel auto-detects Vite/React projects)
6. Click **Deploy**

Your site will be live at `https://your-project-name.vercel.app` in about 60 seconds.

### Option B: Using the Terminal (Faster)

First, install and log in to the Vercel CLI:

```bash
npm install -g vercel
vercel login
```

A browser window will open — sign in with your Vercel account. Once logged in, come back to the terminal and deploy:

```bash
vercel
```

Follow the prompts:
- **Set up and deploy?** Yes
- **Which scope?** Select your account
- **Link to existing project?** No
- **Project name?** Press Enter (uses folder name)
- **Directory?** Press Enter (uses current)

Done. Vercel gives you a live URL.

---

## Step 5: Migrate Environment Variables

If your Lovable project uses Supabase, third-party APIs, or any other services, you need to copy those environment variables to Vercel. **Your site won't work without them.**

### Where to find your keys

1. **In Lovable:** Open your project > Settings > Environment Variables (or check the Supabase integration panel)
2. **In your code:** Look in any `.env` or `.env.local` file in your project, or search for `VITE_` in your code to see which variables it uses

### Common variables from Lovable projects

| Variable | Where to find it |
|----------|-----------------|
| `VITE_SUPABASE_URL` | [Supabase Dashboard](https://supabase.com/dashboard) > Your project > Settings > API |
| `VITE_SUPABASE_ANON_KEY` | Same page as above |
| `VITE_STRIPE_PUBLIC_KEY` | [Stripe Dashboard](https://dashboard.stripe.com/apikeys) |

### Add them to Vercel

**Via Dashboard:**
1. Go to your project on [vercel.com/dashboard](https://vercel.com/dashboard)
2. Click **Settings** > **Environment Variables**
3. Add each variable (name + value), select all environments (Production, Preview, Development)
4. Click **Save**
5. **Redeploy** — go to Deployments tab > click the three dots on the latest deploy > Redeploy

**Via Terminal:**
```bash
vercel env add VITE_SUPABASE_URL
vercel env add VITE_SUPABASE_ANON_KEY
```

Then redeploy with `vercel --prod`.

---

## Step 6: Set Up Auto-Deploy

If you used the Vercel Dashboard (Option A), auto-deploy is already set up. Every time you push to GitHub, Vercel rebuilds and deploys automatically.

If you used the terminal (Option B), connect GitHub in the Vercel dashboard:

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard)
2. Click your project
3. Go to **Settings** > **Git**
4. Click **Connect Git Repository**
5. Select your GitHub repo

Now every `git push` triggers a deploy.

---

## Step 7: Custom Domain (Optional)

If you have a custom domain, you can point it to Vercel.

### Add the Domain in Vercel

1. Go to your project on [vercel.com/dashboard](https://vercel.com/dashboard)
2. Click **Settings** > **Domains**
3. Type your domain (e.g., `yourdomain.com`) and click **Add**
4. Also add `www.yourdomain.com` if you want both to work

### Update DNS Records

Go to wherever you manage your domain (GoDaddy, Namecheap, Cloudflare, Wix, Google Domains, etc.) and update the DNS records:

| Type | Host/Name | Value |
|------|-----------|-------|
| `A` | `@` | `76.76.21.21` |
| `CNAME` | `www` | `cname.vercel-dns.com` |

> **Where to find DNS settings:** Each domain registrar is different. Search for "[your registrar] edit DNS records" for specific instructions.

DNS propagation takes 5-30 minutes (rarely up to 48 hours). Vercel provides free SSL automatically.

---

## Step 8: Update Your Workflow

Once your site is live on Vercel, you can manage it independently:

- Edit your site locally with any code editor or AI coding tool
- Push to GitHub to trigger automatic deploys
- Manage hosting through Vercel's dashboard

If you no longer need your Lovable subscription, you can cancel it from your Lovable account settings. Your code remains in your GitHub repository regardless.

---

## Step 9: Edit Your Site Going Forward

You can use any code editor to modify your site. Here's an example using Claude Code:

```bash
cd your-project-name
claude
```

Then describe what you want in plain English:

- *"Add a contact form to the homepage"*
- *"Change the hero section background to blue"*
- *"Add a new page called /pricing with a 3-tier pricing table"*
- *"Make the site mobile-responsive"*
- *"Add dark mode"*

When you're happy with the changes:

```bash
git add -A
git commit -m "Updated homepage"
git push
```

Vercel auto-deploys in about 30 seconds. Done.

> **Tip:** Claude Code can also handle the git commands for you if you ask it to.

---

## Automated Migration Script

For those comfortable with the terminal, we included a script that handles Steps 2-4 automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/NirDiamant/lovable-to-claude-code/main/migrate.sh | bash -s -- https://github.com/your-username/your-repo.git
```

Or clone this repo and run it locally:

```bash
git clone https://github.com/NirDiamant/lovable-to-claude-code.git
cd lovable-to-claude-code
./migrate.sh https://github.com/your-username/your-repo.git
```

The script will:
1. Check all prerequisites (Node.js, Git, Vercel CLI)
2. Log you in to Vercel if needed
3. Clone your repo (with clear error messages if it fails)
4. Install dependencies and verify the build
5. Deploy to Vercel and print your live URL

> **Note:** The script requires Git Bash on Windows. See the [Prerequisites](#prerequisites) section.

---

## FAQ

### Is Vercel really free?

Yes. Vercel's free Hobby plan includes 100 GB bandwidth/month, automatic SSL, preview deployments, and more. Most personal and small business sites stay well within these limits.

### What if my project uses Supabase?

It keeps working. See [Step 5: Migrate Environment Variables](#step-5-migrate-environment-variables) for detailed instructions on copying your Supabase keys to Vercel.

### Do I need Claude Code specifically?

No. After migration, your site is a standard React/Vite project. You can edit it with VS Code, Cursor, Windsurf, or any editor. Claude Code is just one option for AI-powered editing in the terminal.

### Can I go back to Lovable?

Yes. Your code stays on GitHub. You can reconnect it to Lovable anytime if you want to use their platform again.

### Can I use Netlify or Cloudflare Pages instead of Vercel?

Yes! Your Lovable project is a standard Vite app that works with any static hosting provider:

- **Netlify:** Go to [app.netlify.com](https://app.netlify.com/) > "Import from Git" > select your repo. Build command: `npm run build`, publish directory: `dist`
- **Cloudflare Pages:** Go to [dash.cloudflare.com](https://dash.cloudflare.com/) > Pages > "Connect to Git". Same build settings as above
- **GitHub Pages:** Works too, but doesn't support client-side routing by default

All of these have free tiers. The guide uses Vercel because it auto-detects Vite projects with zero configuration.

### The migration script failed

Try the manual steps (Steps 2-4) instead. Common issues:

- **"command not found: git"** — Install Git from [git-scm.com](https://git-scm.com/downloads)
- **"command not found: node"** — Install Node.js from [nodejs.org](https://nodejs.org/)
- **"command not found: vercel"** — Run `npm install -g vercel` first
- **"Cannot find module"** — Delete `node_modules` and reinstall: `rm -rf node_modules && npm install`
- **"VITE_SUPABASE_URL is not defined" / blank page** — You're missing environment variables. See [Step 5](#step-5-migrate-environment-variables)
- **Build timeout** — Your project may be too large for the default timeout. Try `vercel --build-timeout 600`
- **"Error: EPERM" on Windows** — Close VS Code or other editors that may be locking files, then retry
- **Build errors** — Your project may need specific configuration. Open an [issue](https://github.com/NirDiamant/lovable-to-claude-code/issues) and we'll help.

---

## Why This Works

Lovable projects are standard **React + Vite + Tailwind CSS** apps. Lovable made a good decision not to use any proprietary build system or runtime. Your project is a normal web app, which means it can be hosted anywhere that supports static sites or Node.js.

---

## Contributing

Found something that doesn't work? Have a tip for a specific domain registrar or hosting provider? Open an issue or submit a PR.

---

## Disclaimer

This project is an independent community resource. It is **not** affiliated with, endorsed by, or sponsored by Lovable (Lovable AB), Vercel Inc., or Anthropic PBC. All product names, logos, and trademarks are the property of their respective owners and are used here solely for identification purposes.

This guide documents how to self-host code that you own. Please review the terms of service of any platform you use to ensure compliance. The authors of this guide are not responsible for any consequences of following these instructions.

## License

MIT
