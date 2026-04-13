#!/bin/bash
# =============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Run via: curl -fsSL https://raw.githubusercontent.com/vincenthaywood/ELT-Test/main/setup/mac-setup.sh | bash
# =============================================================
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

# ── Node.js ───────────────────────────────────────────────────
echo -e "${YELLOW}[1/5]${NC} Checking Node.js..."

# Load full PATH — curl|bash strips a lot of locations
export PATH="/usr/local/bin:/usr/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.nvm/versions/node/$(ls $HOME/.nvm/versions/node 2>/dev/null | tail -1)/bin:$PATH"

# Find node wherever it might be
NODE_BIN=$(which node 2>/dev/null || ls /usr/local/bin/node /opt/homebrew/bin/node /opt/local/bin/node 2>/dev/null | head -1)

if [ -z "$NODE_BIN" ]; then
  echo -e "${YELLOW}  Node.js not found — installing automatically...${NC}"

  ARCH=$(uname -m)
  if [ "$ARCH" = "arm64" ]; then
    NODE_PKG="node-v20.11.1-darwin-arm64.pkg"
  else
    NODE_PKG="node-v20.11.1-darwin-x64.pkg"
  fi

  TMP_PKG="/tmp/$NODE_PKG"
  echo "  Downloading Node.js (~30MB)..."
  curl -fsSL "https://nodejs.org/dist/v20.11.1/$NODE_PKG" -o "$TMP_PKG"

  echo "  Installing (you may be asked for your Mac password)..."
  sudo installer -pkg "$TMP_PKG" -target / > /dev/null 2>&1
  rm -f "$TMP_PKG"

  # Reload PATH after install
  export PATH="/usr/local/bin:/usr/bin:$PATH"
  NODE_BIN=$(which node 2>/dev/null)

  if [ -n "$NODE_BIN" ]; then
    echo -e "${GREEN}  ✓ Node.js $($NODE_BIN --version) installed${NC}"
  else
    echo -e "${RED}  ✗ Auto-install failed.${NC}"
    echo "  Please install manually from https://nodejs.org then paste the setup command again."
    exit 1
  fi
else
  echo -e "${GREEN}  ✓ Node.js $($NODE_BIN --version)${NC}"
fi

# Make sure npm is on PATH too
NPM_BIN=$(dirname "$NODE_BIN")/npm

# ── Claude Code ───────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[2/5]${NC} Installing Claude Code..."
CLAUDE_BIN=$(which claude 2>/dev/null || ls /usr/local/bin/claude "$HOME/.npm-global/bin/claude" 2>/dev/null | head -1)

if [ -n "$CLAUDE_BIN" ]; then
  echo -e "${GREEN}  ✓ Already installed${NC}"
else
  echo "  Installing (takes ~30 seconds)..."
  "$NPM_BIN" install -g @anthropic-ai/claude-code --silent
  export PATH="/usr/local/bin:$HOME/.npm-global/bin:$PATH"
  CLAUDE_BIN=$(which claude 2>/dev/null)

  if [ -n "$CLAUDE_BIN" ]; then
    echo -e "${GREEN}  ✓ Installed${NC}"
  else
    echo -e "${RED}  ✗ Failed — please screenshot this and send to Vincent${NC}"
    exit 1
  fi
fi

# ── Team selection ────────────────────────────────────────────
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
  *)
    echo -e "${RED}  Invalid choice. Please run the command again.${NC}"
    exit 1
    ;;
esac

echo -e "${GREEN}  ✓ Team ${BOLD}$TEAM_NAME${NC}${GREEN} selected${NC}"

# ── MCP config ────────────────────────────────────────────────
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

echo -e "${GREEN}  ✓ Supabase, Playwright and Filesystem ready${NC}"

# ── Clone repo + install deps ─────────────────────────────────
echo ""
echo -e "${YELLOW}[5/5]${NC} Downloading workshop files..."

if [ -d "$WORKSHOP/.git" ]; then
  cd "$WORKSHOP" && git pull --quiet
else
  git clone https://github.com/vincenthaywood/ELT-Test.git "$WORKSHOP" --quiet
fi

cd "$WORKSHOP"
"$NPM_BIN" install --silent 2>/dev/null
echo -e "${GREEN}  ✓ Files ready${NC}"

# ── Start dev server ──────────────────────────────────────────
"$NPM_BIN" run dev &>/dev/null &
echo $! > /tmp/workshop-dev.pid
sleep 3
open http://localhost:5173
echo -e "${GREEN}  ✓ Live preview opened at localhost:5173${NC}"

# ── Copy first prompt to clipboard ────────────────────────────
FIRST_PROMPT="Read the file at $WORKSHOP/$TEAM_DIR/CLAUDE.md and then let's start building the $TEAM_NAME module."
echo "$FIRST_PROMPT" | pbcopy
echo -e "${GREEN}  ✓ First prompt copied to clipboard${NC}"

# ── Login ─────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Almost done!${NC} One last step — sign in to Claude."
echo ""
echo "  A browser tab will open. Use your usual claude.ai account."
echo ""
read -p "  Press Enter when ready..."
"$CLAUDE_BIN" login

# ── Done ──────────────────────────────────────────────────────
clear
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════╗"
echo -e "  ║   ✓  You're all set for the workshop!   ║"
echo -e "  ╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Team:    ${BOLD}$TEAM_NAME${NC}"
echo -e "  Preview: ${CYAN}http://localhost:5173${NC}"
echo ""
echo -e "  ${BOLD}On the day:${NC}"
echo "  1. Open Claude Desktop"
echo "  2. Press Cmd+V to paste your first prompt"
echo "  3. Watch the preview update live at localhost:5173"
echo ""
echo -e "  ${YELLOW}You can close this window now.${NC}"
echo ""
