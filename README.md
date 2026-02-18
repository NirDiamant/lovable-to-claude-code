# Self-Host Your Lovable Project for Free

Stop paying for hosting. Deploy your Lovable site to Vercel (free) in minutes.

## 📫 Stay Updated!

<div align="center">
<table>
<tr>
<td align="center">🚀<br><b>Cutting-edge<br>Updates</b></td>
<td align="center">💡<br><b>Expert<br>Insights</b></td>
<td align="center">🎯<br><b>Top 0.1%<br>Content</b></td>
</tr>
</table>

[![Subscribe to DiamantAI Newsletter](images/subscribe-button.svg)](https://diamantai.substack.com/?r=336pe4&utm_campaign=pub-share-checklist)

*Join over 50,000 AI enthusiasts getting unique cutting-edge insights and free tutorials!*
</div>

[![DiamantAI's newsletter](images/substack_image.png)](https://diamantai.substack.com/?r=336pe4&utm_campaign=pub-share-checklist)

---

## 3 Steps

### 1. Install prerequisites

- [Node.js](https://nodejs.org/) v18+ (download and run the installer)
- [Git](https://git-scm.com/downloads) (most Macs already have it)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) (`npm install -g @anthropic-ai/claude-code`)

### 2. Clone this repo

```bash
git clone https://github.com/NirDiamant/lovable-to-claude-code.git
cd lovable-to-claude-code
```

### 3. Run Claude

```bash
claude
```

That's it. Claude reads the instructions in this repo and walks you through everything: cloning your Lovable project, building it, deploying to Vercel, and setting up auto-deploys. Just answer its questions.

---

## What happens when you run `claude`

1. Claude asks for your Lovable project's GitHub repo URL
2. Clones your project and installs dependencies
3. Verifies the build works
4. Logs you into Vercel (if needed) and deploys
5. Gives you a live URL and next steps

You stay in control the whole time. Claude asks before running each command.

---

## Don't have Claude Code?

Use the migration script instead:

```bash
./migrate.sh https://github.com/your-username/your-repo.git
```

Or run it directly without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/NirDiamant/lovable-to-claude-code/main/migrate.sh | bash -s -- https://github.com/your-username/your-repo.git
```

> **Windows users:** Use [Git Bash](https://git-scm.com/downloads) (comes with Git for Windows). PowerShell and CMD won't work.

---

## How it compares

| What | Lovable | Self-Hosted (This Guide) |
|------|---------|-------------------------|
| AI code generation | Built-in browser editor | Any AI code editor (Claude Code, Cursor, etc.) |
| Hosting | Lovable servers | Vercel free tier |
| Auto-deploy | On save | On git push |

> **Note:** Lovable is still the easiest way to *build* a website from scratch with AI. This guide is for after you've built your site and want free hosting.

---

## FAQ

**Is Vercel really free?**
Yes. The free Hobby plan includes 100 GB bandwidth/month, automatic SSL, and preview deployments. Most personal sites stay well within these limits.

**What if my project uses Supabase?**
Claude (or the migration script) will help you set up the environment variables (`VITE_SUPABASE_URL`, etc.) in Vercel.

**Do I need Claude Code specifically?**
No. After migration, your site is a standard React/Vite project. You can edit it with VS Code, Cursor, Windsurf, or any editor. Claude Code just makes the migration hands-free.

**Can I use Netlify or Cloudflare Pages instead of Vercel?**
Yes. Your Lovable project is a standard Vite app. Use build command `npm run build` and publish directory `dist` on any static host.

**Can I go back to Lovable?**
Yes. Your code stays on GitHub. Reconnect it to Lovable anytime.

**Something went wrong?**
Open an [issue](https://github.com/NirDiamant/lovable-to-claude-code/issues) and we'll help.

---

## Disclaimer

This project is an independent community resource. It is **not** affiliated with, endorsed by, or sponsored by Lovable (Lovable AB), Vercel Inc., or Anthropic PBC. All product names, logos, and trademarks are the property of their respective owners.

This guide documents how to self-host code that you own. Please review the terms of service of any platform you use. The authors are not responsible for any consequences of following these instructions.

## License

MIT
