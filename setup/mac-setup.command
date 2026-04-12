#!/bin/bash

# ============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Double-click this file to run it
# ============================================================

# Open in Terminal if not already
cd "$(dirname "$0")/.."

clear
echo "============================================"
echo "   Spendesk Rebuild Workshop — Mac Setup"
echo "============================================"
echo ""

# ── Helper functions ─────────────────────────────────────
ok()   { echo "  ✅ $1"; }
fail() { echo "  ❌ $1"; echo ""; echo "Something went wrong. Screenshot this and send to Vincent."; read -p "Press Enter to close..."; exit 1; }
info() { echo "  ➜  $1"; }

# ── Step 1: Check Node.js ─────────────────────────────────
echo "Step 1 of 4 — Checking Node.js..."
if command -v node &>/dev/null; then
  NODE_VER=$(node --version)
  ok "Node.js found ($NODE_VER)"
else
  echo ""
  echo "  ❌ Node.js not found."
  echo ""
  echo "  Please install it first:"
  echo "  1. Go to https://nodejs.org"
  echo "  2. Click the big green LTS button"
  echo "  3. Run the installer"
  echo "  4. Double-click this setup file again"
  echo ""
  read -p "Press Enter to open nodejs.org in your browser..."
  open https://nodejs.org
  exit 1
fi

# ── Step 2: Install Claude Code ──────────────────────────
echo ""
echo "Step 2 of 4 — Installing Claude Code..."
if command -v claude &>/dev/null; then
  ok "Claude Code already installed ($(claude --version 2>/dev/null || echo 'ready'))"
else
  info "Installing Claude Code (takes ~30 seconds)..."
  npm install -g @anthropic-ai/claude-code
  if command -v claude &>/dev/null; then
    ok "Claude Code installed"
  else
    fail "Claude Code install failed. Try running in Terminal: npm install -g @anthropic-ai/claude-code"
  fi
fi

# ── Step 3: Login ─────────────────────────────────────────
echo ""
echo "Step 3 of 4 — Logging in to Claude..."
echo ""
echo "  A browser window will open. Sign in with your usual claude.ai account."
echo ""
read -p "  Press Enter when ready..."
claude login
echo ""
ok "Claude login complete"

# ── Step 4: Configure MCPs ───────────────────────────────
echo ""
echo "Step 4 of 4 — Configuring workshop tools (MCPs)..."
mkdir -p ~/.claude

cat > ~/.claude/settings.json << 'EOF'
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--supabase-url", "https://beafagckgeidshnoikzg.supabase.co",
        "--supabase-api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest", "--headless"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME/spendesk-workshop"]
    }
  }
}
EOF

ok "Workshop tools configured"

# ── Step 5: Create workshop folder and install deps ──────
echo ""
echo "Setting up workshop folder..."
WORKSHOP_DIR="$HOME/spendesk-workshop"
mkdir -p "$WORKSHOP_DIR"

# Copy repo files to workshop folder
cp -r "$(dirname "$0")/.."/* "$WORKSHOP_DIR/" 2>/dev/null || true

# Install npm deps
cd "$WORKSHOP_DIR"
npm install --silent 2>/dev/null || true

ok "Workshop folder ready at ~/spendesk-workshop"

# ── Done ─────────────────────────────────────────────────
echo ""
echo "============================================"
echo "   ✅ You're all set for the workshop!"
echo "============================================"
echo ""
echo "  On the day, Vincent will tell you which"
echo "  team you're on and what to type."
echo ""
echo "  Your workshop folder is at:"
echo "  ~/spendesk-workshop"
echo ""
read -p "Press Enter to close..."
