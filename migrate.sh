#!/bin/bash

# Lovable to Vercel Migration Script
# Clones your Lovable repo, verifies it builds, and deploys to Vercel (free)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() { echo -e "\n${BLUE}[$1/5]${NC} $2"; }
print_ok() { echo -e "${GREEN}OK${NC} $1"; }
print_warn() { echo -e "${YELLOW}WARNING${NC} $1"; }
print_err() { echo -e "${RED}ERROR${NC} $1"; }

# --- Windows / environment warning ---
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        echo ""
        print_warn "Windows detected. This script requires Git Bash (comes with Git for Windows)."
        print_warn "If you're in PowerShell or CMD, please open Git Bash and run this script there."
        echo ""
        ;;
esac

# --- Check arguments ---
if [ -z "$1" ]; then
    echo ""
    echo "Usage: ./migrate.sh <github-repo-url>"
    echo ""
    echo "Example:"
    echo "  ./migrate.sh https://github.com/your-username/your-project.git"
    echo ""
    echo "Find your repo URL in Lovable: GitHub icon (top-right) > click repo link > green Code button > copy HTTPS URL"
    echo ""
    exit 1
fi

REPO_URL="$1"
REPO_NAME=$(basename "$REPO_URL" .git)

echo ""
echo "========================================="
echo "  Lovable to Vercel Migration"
echo "========================================="
echo ""
echo "Repo: $REPO_URL"
echo ""

# --- Check prerequisites ---
print_step 1 "Checking prerequisites..."

MISSING=0

if ! command -v git &> /dev/null; then
    print_err "git is not installed. Download it from https://git-scm.com/downloads"
    MISSING=1
fi

if ! command -v node &> /dev/null; then
    print_err "Node.js is not installed. Download it from https://nodejs.org/"
    MISSING=1
else
    NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_err "Node.js v18+ required. You have $(node --version). Update at https://nodejs.org/"
        MISSING=1
    else
        print_ok "Node.js $(node --version)"
    fi
fi

if ! command -v npm &> /dev/null; then
    print_err "npm is not installed. It comes with Node.js - reinstall from https://nodejs.org/"
    MISSING=1
else
    print_ok "npm $(npm --version)"
fi

if [ "$MISSING" -eq 1 ]; then
    echo ""
    print_err "Please install the missing tools above and run this script again."
    exit 1
fi

# Check for Vercel CLI (install if missing)
if ! command -v vercel &> /dev/null; then
    print_warn "Vercel CLI not found. Installing..."
    npm install -g vercel
    if ! command -v vercel &> /dev/null; then
        print_err "Failed to install Vercel CLI. Try: npm install -g vercel"
        exit 1
    fi
fi
print_ok "Vercel CLI $(vercel --version 2>/dev/null | head -1)"

# Check Vercel authentication
echo ""
echo "Checking Vercel login status..."
if ! vercel whoami &> /dev/null; then
    print_warn "You're not logged in to Vercel. Let's fix that."
    echo ""
    echo "A browser window will open for you to log in to Vercel."
    echo "After logging in, come back here."
    echo ""
    vercel login
    if ! vercel whoami &> /dev/null; then
        print_err "Vercel login failed. Please run 'vercel login' manually and try again."
        exit 1
    fi
fi
VERCEL_USER=$(vercel whoami 2>/dev/null)
print_ok "Logged in to Vercel as $VERCEL_USER"

print_ok "All prerequisites met"

# --- Clone repo ---
print_step 2 "Cloning your Lovable project..."

if [ -d "$REPO_NAME" ]; then
    echo ""
    print_warn "Folder '$REPO_NAME' already exists."
    echo ""
    echo "Options:"
    echo "  1. Press Enter to use the existing folder as-is"
    echo "  2. Press Ctrl+C to cancel, then rename/delete the folder and re-run"
    echo ""
    read -r -p "Press Enter to continue with existing folder... "
    cd "$REPO_NAME"
    print_ok "Using existing folder ./$REPO_NAME"
else
    if ! git clone "$REPO_URL" 2>&1; then
        echo ""
        print_err "Failed to clone the repository."
        echo ""
        echo "This usually means one of:"
        echo "  1. The repo URL is wrong — double-check it in Lovable/GitHub"
        echo "  2. The repo is private — you need to authenticate:"
        echo ""
        echo "     Option A: Use SSH instead of HTTPS"
        echo "       git clone git@github.com:your-username/your-project.git"
        echo "       (requires SSH key setup: https://docs.github.com/en/authentication/connecting-to-github-with-ssh)"
        echo ""
        echo "     Option B: Use a Personal Access Token"
        echo "       git clone https://YOUR_TOKEN@github.com/your-username/your-project.git"
        echo "       (create one at: https://github.com/settings/tokens)"
        echo ""
        echo "     Option C: Install GitHub CLI"
        echo "       brew install gh && gh auth login"
        echo "       Then re-run this script."
        echo ""
        exit 1
    fi
    cd "$REPO_NAME"
    print_ok "Project cloned to ./$REPO_NAME"
fi

# --- Install and build ---
print_step 3 "Installing dependencies..."

npm install

print_ok "Dependencies installed"

print_step 4 "Verifying build..."

if ! npm run build; then
    echo ""
    print_err "Build failed."
    echo ""
    echo "Common causes:"
    echo "  - Missing environment variables (VITE_SUPABASE_URL, etc.)"
    echo "    Create a .env file in the project folder with your variables."
    echo "    Check your Lovable project settings for the values."
    echo ""
    echo "  - TypeScript errors from outdated dependencies"
    echo "    Try: npm update && npm run build"
    echo ""
    echo "  - 'Cannot find module' errors"
    echo "    Try: rm -rf node_modules && npm install && npm run build"
    echo ""
    echo "If you're stuck, open an issue at:"
    echo "  https://github.com/NirDiamant/lovable-to-claude-code/issues"
    echo ""
    exit 1
fi

print_ok "Build successful"

# --- Deploy to Vercel ---
print_step 5 "Deploying to Vercel..."

echo ""
echo "Setting up Vercel project..."
if ! vercel --yes; then
    print_err "Vercel project setup failed. Please check the error above."
    exit 1
fi

# Deploy to production
echo ""
echo "Deploying to production..."
DEPLOY_OUTPUT=$(vercel --prod 2>&1)
DEPLOY_EXIT=$?

if [ "$DEPLOY_EXIT" -ne 0 ]; then
    echo ""
    print_err "Production deploy failed."
    echo ""
    echo "Vercel output:"
    echo "$DEPLOY_OUTPUT"
    echo ""
    echo "Common fixes:"
    echo "  - Add environment variables: vercel env add VITE_SUPABASE_URL"
    echo "  - Check build logs: vercel logs"
    echo ""
    exit 1
fi

# Strip ANSI codes and extract URL
PROD_URL=$(echo "$DEPLOY_OUTPUT" | sed 's/\x1b\[[0-9;]*m//g' | grep -oE 'https://[^ ]+' | head -1)

echo ""
echo "========================================="
echo -e "  ${GREEN}Migration Complete!${NC}"
echo "========================================="
echo ""

if [ -n "$PROD_URL" ]; then
    echo -e "Your site is live at: ${GREEN}$PROD_URL${NC}"
else
    echo "Your site is deployed! Check vercel.com/dashboard for the URL."
fi

echo ""
echo "Next steps:"
echo "  1. Visit your Vercel dashboard to connect a custom domain (optional)"
echo "  2. Add environment variables in Vercel if your app uses them"
echo "     (Project > Settings > Environment Variables)"
echo "  3. Cancel your Lovable subscription"
echo "  4. Edit your site locally and 'git push' to deploy"
echo ""
echo "To edit with Claude Code:"
echo "  cd $REPO_NAME"
echo "  claude"
echo ""
echo "To deploy changes:"
echo "  git add -A && git commit -m \"your changes\" && git push"
echo ""
