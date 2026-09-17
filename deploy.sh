#!/bin/bash
# MoreYi v3 — GitHub Deployment Script
# Usage: GITHUB_TOKEN=ghp_xxx ./deploy.sh
# Or set up SSH keys first: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

REPO="https://github.com/FrankChang-723/moreyi-website.git"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== MoreYi v3 Deploy ==="
echo "Directory: $DIR"
echo ""

# Check for git
if ! command -v git &> /dev/null; then
    echo "ERROR: git not installed"
    exit 1
fi

cd "$DIR"

# If token is provided, use it
if [ -n "$GITHUB_TOKEN" ]; then
    REMOTE="https://FrankChang-723:${GITHUB_TOKEN}@github.com/FrankChang-723/moreyi-website.git"
    echo "Using token auth..."
elif [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_PASS" ]; then
    REMOTE="https://${GITHUB_USER}:${GITHUB_PASS}@github.com/FrankChang-723/moreyi-website.git"
    echo "Using user/pass auth..."
else
    # Try SSH
    REMOTE="git@github.com:FrankChang-723/moreyi-website.git"
    echo "Trying SSH auth..."
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" || {
        echo ""
        echo "⚠️  No GitHub auth found!"
        echo ""
        echo "Options:"
        echo "  1) Create a token: https://github.com/settings/tokens"
        echo "     Then: GITHUB_TOKEN=ghp_xxx ./deploy.sh"
        echo ""
        echo "  2) Setup SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
        echo ""
        echo "  3) Use Vercel drag-and-drop instead:"
        echo "     Open https://vercel.com/drop"
        echo "     Drag: $DIR/index.html"
        echo ""
        echo "  4) Use Netlify drag-and-drop:"
        echo "     Open https://app.netlify.com/drop"
        echo "     Drag the entire $DIR folder"
        exit 1
    }
fi

# Check if remote already exists
if git remote get-url origin &>/dev/null; then
    git remote set-url origin "$REMOTE"
else
    git remote add origin "$REMOTE"
fi

echo "Pushing to GitHub..."
echo "Remote: $REPO"

# Try to pull first, merge, then push
if git pull origin master --rebase 2>/dev/null; then
    echo "Merged with remote..."
fi

git push -u origin master --force 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Deployed! Check: https://github.com/FrankChang-723/moreyi-website"
    echo ""
    echo "To enable GitHub Pages:"
    echo "  1. Go to https://github.com/FrankChang-723/moreyi-website/settings/pages"
    echo "  2. Source: Deploy from a branch"
    echo "  3. Branch: master, / (root)"
    echo "  4. Save → Your site will be at https://frankchang-723.github.io/moreyi-website/"
else
    echo ""
    echo "✗ Push failed. Try alternative deployment:"
    echo "  - Vercel: https://vercel.com/drop"
    echo "  - Netlify: https://app.netlify.com/drop"
fi
