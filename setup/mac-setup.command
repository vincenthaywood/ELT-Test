#!/bin/bash
# =============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Double-click this file in Finder to run
# =============================================================
cd "$(dirname "$0")"
clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${BOLD}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}  ║   Spendesk Workshop — Mac Setup          ║${NC}"
echo -e "${BOLD}  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ── Node.js check ────────────────────────────────────────────
echo -e "${YELLOW}[1/4]${NC} Checking Node.js..."
if ! command -v node &>/dev/null; then
  echo -e "${RED}  ✗ Node.js not found.${NC}"
  echo ""
  echo "  Please install it first:"
  echo "  → Go to https://nodejs.org and click the LTS button"
  echo "  → Run the installer, then double-click this file again"
  echo ""
  open https://nodejs.org
  read -p "  Press Enter to close..."
  exit 1
fi
echo -e "${GREEN}  ✓ Node.js $(node --version)${NC}"

# ── Claude Code ───────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[2/4]${NC} Installing Claude Code..."
if command -v claude &>/dev/null; then
  echo -e "${GREEN}  ✓ Already installed${NC}"
else
  npm install -g @anthropic-ai/claude-code --silent
  if command -v claude &>/dev/null; then
    echo -e "${GREEN}  ✓ Claude Code installed${NC}"
  else
    echo -e "${RED}  ✗ Install failed. Try opening Terminal and running:${NC}"
    echo "    npm install -g @anthropic-ai/claude-code"
    read -p "  Press Enter to close..."
    exit 1
  fi
fi

# ── MCP config ────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[3/4]${NC} Configuring workshop tools..."
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'MCPEOF'
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
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/$USER/spendesk-workshop"
      ]
    }
  }
}
MCPEOF
echo -e "${GREEN}  ✓ Supabase, Playwright and Filesystem configured${NC}"

# ── Workshop folder ───────────────────────────────────────────
echo ""
echo -e "${YELLOW}[4/4]${NC} Setting up your workshop folder..."
WORKSHOP="$HOME/spendesk-workshop"

# Clone or update repo
if [ -d "$WORKSHOP/.git" ]; then
  echo "  Updating existing workshop folder..."
  cd "$WORKSHOP" && git pull --quiet
else
  echo "  Downloading workshop files..."
  git clone https://github.com/vincenthaywood/ELT-Test.git "$WORKSHOP" --quiet 2>/dev/null
fi

# Install dependencies
cd "$WORKSHOP"
npm install --silent 2>/dev/null
echo -e "${GREEN}  ✓ Workshop folder ready${NC}"

# ── Start dev server in background ───────────────────────────
echo ""
echo "  Starting live preview..."
npm run dev &>/dev/null &
DEV_PID=$!
echo $DEV_PID > /tmp/workshop-dev.pid

# Give Vite a moment to start
sleep 3

# Open browser
open http://localhost:5173
echo -e "${GREEN}  ✓ Preview opened at localhost:5173${NC}"

# ── Login ──────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Almost done!${NC} Just need to log in to Claude."
echo ""
echo "  A browser tab will open — sign in with your claude.ai account."
echo ""
read -p "  Press Enter when ready..."
cd "$WORKSHOP"
claude login

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}  ║   ✓  You're all set for the workshop!   ║${NC}"
echo -e "${GREEN}${BOLD}  ╚══════════════════════════════════════════╝${NC}"
echo ""
echo "  Your live preview is running at:"
echo -e "  ${BOLD}http://localhost:5173${NC}"
echo ""
echo "  On the day Vincent will tell you:"
echo "  - Which team you're on"
echo "  - What to type into Claude Desktop"
echo ""
read -p "  Press Enter to close this window..."
