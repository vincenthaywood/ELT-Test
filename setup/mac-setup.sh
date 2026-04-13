#!/bin/bash
# =============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Run via: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vincenthaywood/ELT-Test/main/setup/mac-setup.sh)"
# =============================================================
clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'
CYAN='\033[0;36m'
REPO="https://raw.githubusercontent.com/vincenthaywood/ELT-Test/main"
CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

echo ""
echo -e "${BOLD}  ╔══════════════════════════════════════════╗"
echo -e "  ║   Spendesk Workshop — Mac Setup          ║"
echo -e "  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ── Find npx — Claude Desktop needs the full path ────────────
# Claude Desktop launches with a stripped PATH so 'npx' alone won't work
export PATH="/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:$PATH"
NPX_PATH=$(which npx 2>/dev/null)

if [ -z "$NPX_PATH" ]; then
  echo -e "${YELLOW}  npx not found — Node.js may not be installed.${NC}"
  echo "  Please install Node.js from https://nodejs.org then run this again."
  exit 1
fi

echo -e "${GREEN}  ✓ Found npx at $NPX_PATH${NC}"

# ── Team selection ────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[1/3]${NC} ${BOLD}Which team are you on?${NC}"
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
  1) TEAM_DIR="team-cards";       TEAM_NAME="Cards";       SPENDESK_SECTION="Cards" ;;
  2) TEAM_DIR="team-expenses";    TEAM_NAME="Expenses";    SPENDESK_SECTION="Expense Claims" ;;
  3) TEAM_DIR="team-approvals";   TEAM_NAME="Approvals";   SPENDESK_SECTION="Requests / Approvals" ;;
  4) TEAM_DIR="team-analytics";   TEAM_NAME="Analytics";   SPENDESK_SECTION="Analytics / Dashboard" ;;
  5) TEAM_DIR="team-budgets";     TEAM_NAME="Budgets";     SPENDESK_SECTION="Budgets" ;;
  6) TEAM_DIR="team-procurement"; TEAM_NAME="Procurement"; SPENDESK_SECTION="Purchase Orders" ;;
  *)
    echo "  Invalid choice. Run the command again."
    exit 1
    ;;
esac

echo -e "${GREEN}  ✓ Team ${BOLD}$TEAM_NAME${NC}"

# ── Create folder + download files ───────────────────────────
echo ""
echo -e "${YELLOW}[2/3]${NC} Setting up workshop folder..."

WORKSHOP="$HOME/spendesk-workshop/$TEAM_DIR"
SHARED="$HOME/spendesk-workshop/shared"
DESIGN="$HOME/spendesk-workshop/design-system"

mkdir -p "$WORKSHOP" "$SHARED" "$DESIGN"

curl -fsSL "$REPO/$TEAM_DIR/CLAUDE.md"      -o "$WORKSHOP/CLAUDE.md"
curl -fsSL "$REPO/shared/supabase.js"       -o "$SHARED/supabase.js"
curl -fsSL "$REPO/shared/auth.js"           -o "$SHARED/auth.js"
curl -fsSL "$REPO/design-system/tokens.css" -o "$DESIGN/tokens.css"

echo -e "${GREEN}  ✓ Files ready at ~/spendesk-workshop/$TEAM_DIR${NC}"

# ── Write MCP config for Claude Desktop ──────────────────────
echo ""
echo -e "${YELLOW}[3/3]${NC} Configuring Claude Desktop tools..."

mkdir -p "$HOME/Library/Application Support/Claude"

# Use the detected full path to npx so Claude Desktop can find it
cat > "$CLAUDE_DESKTOP_CONFIG" << MCPEOF
{
  "mcpServers": {
    "supabase": {
      "command": "$NPX_PATH",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--supabase-url", "https://beafagckgeidshnoikzg.supabase.co",
        "--supabase-api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs"
      ]
    },
    "playwright": {
      "command": "$NPX_PATH",
      "args": ["-y", "@playwright/mcp@latest", "--headless"]
    },
    "filesystem": {
      "command": "$NPX_PATH",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$HOME/spendesk-workshop"
      ]
    }
  }
}
MCPEOF

echo -e "${GREEN}  ✓ Supabase, Playwright and Filesystem configured${NC}"
echo -e "  ${CYAN}Using npx at: $NPX_PATH${NC}"

# ── Copy first prompt to clipboard ────────────────────────────
FIRST_PROMPT="I am on the $TEAM_NAME team. My working folder is $HOME/spendesk-workshop/$TEAM_DIR — all files go there. Read $HOME/spendesk-workshop/$TEAM_DIR/CLAUDE.md to understand the context. Then ask me to log in to Spendesk so you can explore the $SPENDESK_SECTION section before we build anything."
echo "$FIRST_PROMPT" | pbcopy

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════╗"
echo -e "  ║   ✓  All done!                           ║"
echo -e "  ╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Team:    ${BOLD}$TEAM_NAME${NC}"
echo -e "  Section: ${CYAN}$SPENDESK_SECTION${NC}"
echo -e "  Folder:  ${CYAN}~/spendesk-workshop/$TEAM_DIR${NC}"
echo ""
echo -e "${YELLOW}  ⚠  Quit and reopen Claude Desktop now${NC}"
echo "     so it picks up the new tools."
echo ""
echo -e "  ${BOLD}On the day:${NC}"
echo "  1. Quit and reopen Claude Desktop"
echo "  2. Press Cmd+V to paste your first prompt"
echo "  3. Claude will ask you to log in to Spendesk"
echo "  4. It explores your section, shows you what it found"
echo "  5. Say 'yes' when you're ready to build"
echo ""
read -p "  Press Enter to close..."
