#!/bin/bash
# =============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Double-click this file in Finder to run
# =============================================================
cd "$(dirname "$0")/.."
clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'
CYAN='\033[0;36m'

echo ""
echo -e "${BOLD}  ╔══════════════════════════════════════════╗"
echo -e "  ║   Spendesk Workshop — Mac Setup          ║"
echo -e "  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ── Node.js check ───────────────────────────────────────────
echo -e "${YELLOW}[1/5]${NC} Checking Node.js..."
if ! command -v node &>/dev/null; then
  echo -e "${RED}  ✗ Node.js not found.${NC}"
  echo "  → Go to https://nodejs.org, install it, then double-click this file again"
  open https://nodejs.org
  read -p "  Press Enter to close..."
  exit 1
fi
echo -e "${GREEN}  ✓ Node.js $(node --version)${NC}"

# ── Claude Code ───────────────────────────────────────────
echo ""
echo -e "${YELLOW}[2/5]${NC} Installing Claude Code..."
if command -v claude &>/dev/null; then
  echo -e "${GREEN}  ✓ Already installed${NC}"
else
  npm install -g @anthropic-ai/claude-code --silent
  command -v claude &>/dev/null && echo -e "${GREEN}  ✓ Installed${NC}" || { echo -e "${RED}  ✗ Failed — send screenshot to Vincent${NC}"; read -p ""; exit 1; }
fi

# ── Team selection ─────────────────────────────────────────
echo ""
echo -e "${YELLOW}[3/5]${NC} ${BOLD}Which team are you on?${NC}"
echo ""
echo -e "  ${CYAN}1)${NC} Cards"
echo -e "  ${CYAN}2)${NC} Expenses"
echo -e "  ${CYAN}3)${NC} Approvals"
echo -e "  ${CYAN}4)${NC} Analytics"
echo -e "  ${CYAN}5)${NC} Budgets"
echo -e "  ${CYAN}6)${NC} Procurement"
echo ""
read -p "  Enter number (1-6): " TEAM_NUM

case $TEAM_NUM in
  1) TEAM_DIR="team-cards";       TEAM_NAME="Cards" ;;
  2) TEAM_DIR="team-expenses";    TEAM_NAME="Expenses" ;;
  3) TEAM_DIR="team-approvals";   TEAM_NAME="Approvals" ;;
  4) TEAM_DIR="team-analytics";   TEAM_NAME="Analytics" ;;
  5) TEAM_DIR="team-budgets";     TEAM_NAME="Budgets" ;;
  6) TEAM_DIR="team-procurement"; TEAM_NAME="Procurement" ;;
  *) echo -e "${RED}  Invalid choice${NC}"; read -p ""; exit 1 ;;
esac

echo -e "${GREEN}  ✓ Team $TEAM_NAME selected${NC}"

# ── MCP config ───────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[4/5]${NC} Configuring workshop tools..."
mkdir -p ~/.claude
WORKSHOP="$HOME/spendesk-workshop"

cat > ~/.claude/settings.json << MCPEOF
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
        "$WORKSHOP/$TEAM_DIR"
      ]
    }
  }
}
MCPEOF
echo -e "${GREEN}  ✓ Supabase, Playwright and Filesystem configured${NC}"
echo -e "     ${CYAN}(Filesystem locked to your team folder only)${NC}"

# ── Workshop folder ───────────────────────────────────────────
echo ""
echo -e "${YELLOW}[5/5]${NC} Setting up workshop folder..."

if [ -d "$WORKSHOP/.git" ]; then
  cd "$WORKSHOP" && git pull --quiet
else
  git clone https://github.com/vincenthaywood/ELT-Test.git "$WORKSHOP" --quiet
fi

cd "$WORKSHOP"
npm install --silent 2>/dev/null
echo -e "${GREEN}  ✓ Workshop files ready${NC}"

# ── Start dev server ─────────────────────────────────────────
npm run dev &>/dev/null &
echo $! > /tmp/workshop-dev.pid
sleep 3
open http://localhost:5173
echo -e "${GREEN}  ✓ Live preview opened at localhost:5173${NC}"

# ── Write first prompt to clipboard ───────────────────────
FIRST_PROMPT="Read the file at $WORKSHOP/$TEAM_DIR/CLAUDE.md and then let's start building the $TEAM_NAME module."
echo "$FIRST_PROMPT" | pbcopy
echo -e "${GREEN}  ✓ Your first prompt is copied to clipboard — just paste it into Claude Desktop${NC}"

# ── Login ────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Almost done!${NC} Sign in to Claude."
echo "  A browser tab will open — use your usual claude.ai account."
echo ""
read -p "  Press Enter when ready..."
claude login

# ── Done ────────────────────────────────────────────────────
clear
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════╗"
echo -e "  ║   ✓  You're all set!                     ║"
echo -e "  ╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Team:    ${BOLD}$TEAM_NAME${NC}"
echo -e "  Folder:  ${CYAN}$WORKSHOP/$TEAM_DIR${NC}"
echo -e "  Preview: ${CYAN}http://localhost:5173${NC}"
echo ""
echo -e "  ${BOLD}On the day:${NC}"
echo "  1. Open Claude Desktop"
echo "  2. Paste your first prompt (already in your clipboard!)"
echo "  3. Watch the preview update as Claude builds"
echo ""
read -p "  Press Enter to close..."
