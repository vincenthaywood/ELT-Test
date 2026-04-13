#!/bin/bash
# =============================================================
# SPENDESK WORKSHOP SETUP — MAC
# Run via: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vincenthaywood/ELT-Test/main/setup/mac-setup.sh)"
# =============================================================
clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

# ── Expand PATH to cover all common Node locations ────────────
export PATH="/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/opt/local/bin:$HOME/.nvm/versions/node/$(ls $HOME/.nvm/versions/node 2>/dev/null | tail -1)/bin:$PATH"

# ── Install Homebrew + Node if needed ────────────────────────
echo -e "${YELLOW}[1/4]${NC} Checking Node.js..."

NODE_PATH=$(which node 2>/dev/null)
NPM_PATH=$(which npm 2>/dev/null)

if [ -z "$NODE_PATH" ]; then
  echo -e "${YELLOW}  Node.js not found — installing via Homebrew...${NC}"

  # Install Homebrew if not present
  if ! command -v brew &>/dev/null; then
    echo "  Installing Homebrew first (you may be asked for your Mac password)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [ -f "/opt/homebrew/bin/brew" ]; then
      export PATH="/opt/homebrew/bin:$PATH"   # M1/M2/M3/M4/M5
    else
      export PATH="/usr/local/bin:$PATH"       # Intel
    fi
  fi

  echo "  Installing Node.js via Homebrew..."
  brew install node --quiet

  # Reload PATH
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
  NODE_PATH=$(which node 2>/dev/null)
  NPM_PATH=$(which npm 2>/dev/null)

  if [ -n "$NODE_PATH" ]; then
    echo -e "${GREEN}  ✓ Node.js $(node --version) installed${NC}"
  else
    echo -e "${RED}  ✗ Node.js install failed.${NC}"
    echo "  Please install manually from https://nodejs.org and run this again."
    exit 1
  fi
else
  echo -e "${GREEN}  ✓ Node.js $(node --version)${NC}"
fi

# ── Team selection ────────────────────────────────────────────
echo ""
echo -e "${YELLOW}[2/4]${NC} ${BOLD}Which team are you on?${NC}"
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

# ── Install MCP packages globally ────────────────────────────
echo ""
echo -e "${YELLOW}[3/4]${NC} Installing workshop tools (takes ~1 min)..."

"$NPM_PATH" install -g \
  @supabase/mcp-server-supabase \
  @playwright/mcp \
  @modelcontextprotocol/server-filesystem \
  --silent 2>/dev/null

# Find installed binary paths
NPM_PREFIX=$("$NPM_PATH" config get prefix 2>/dev/null)
NPM_BIN="$NPM_PREFIX/bin"
NPX_PATH="$NPM_BIN/npx"
[ ! -f "$NPX_PATH" ] && NPX_PATH=$(which npx 2>/dev/null)

SUPABASE_BIN="$NPM_BIN/mcp-server-supabase"
PLAYWRIGHT_BIN="$NPM_BIN/mcp-server-playwright"
FILESYSTEM_BIN="$NPM_BIN/mcp-server-filesystem"

[ ! -f "$SUPABASE_BIN" ]   && SUPABASE_BIN=$(which mcp-server-supabase 2>/dev/null || echo "$NPX_PATH")
[ ! -f "$PLAYWRIGHT_BIN" ] && PLAYWRIGHT_BIN=$(which mcp-server-playwright 2>/dev/null || echo "$NPX_PATH")
[ ! -f "$FILESYSTEM_BIN" ] && FILESYSTEM_BIN=$(which mcp-server-filesystem 2>/dev/null || echo "$NPX_PATH")

echo -e "${GREEN}  ✓ Tools installed${NC}"

# ── Download workshop files ───────────────────────────────────
echo ""
echo -e "${YELLOW}[4/4]${NC} Setting up workshop folder + configuring Claude Desktop..."

WORKSHOP="$HOME/spendesk-workshop/$TEAM_DIR"
SHARED="$HOME/spendesk-workshop/shared"
DESIGN="$HOME/spendesk-workshop/design-system"

mkdir -p "$WORKSHOP" "$SHARED" "$DESIGN"

curl -fsSL "$REPO/$TEAM_DIR/CLAUDE.md"      -o "$WORKSHOP/CLAUDE.md"
curl -fsSL "$REPO/shared/supabase.js"       -o "$SHARED/supabase.js"
curl -fsSL "$REPO/shared/auth.js"           -o "$SHARED/auth.js"
curl -fsSL "$REPO/design-system/tokens.css" -o "$DESIGN/tokens.css"

echo -e "${GREEN}  ✓ Files ready at ~/spendesk-workshop/$TEAM_DIR${NC}"

# ── Write Claude Desktop MCP config ──────────────────────────
mkdir -p "$HOME/Library/Application Support/Claude"

# Build args based on whether we have installed binaries or need npx fallback
if [ -f "$SUPABASE_BIN" ] && [ "$SUPABASE_BIN" != "$NPX_PATH" ]; then
  SUPABASE_CMD="$SUPABASE_BIN"
  SUPABASE_ARGS="[\"--supabase-url\", \"https://beafagckgeidshnoikzg.supabase.co\", \"--supabase-api-key\", \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs\"]"
else
  SUPABASE_CMD="$NPX_PATH"
  SUPABASE_ARGS="[\"-y\", \"@supabase/mcp-server-supabase\", \"--supabase-url\", \"https://beafagckgeidshnoikzg.supabase.co\", \"--supabase-api-key\", \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs\"]"
fi

if [ -f "$PLAYWRIGHT_BIN" ] && [ "$PLAYWRIGHT_BIN" != "$NPX_PATH" ]; then
  PLAYWRIGHT_CMD="$PLAYWRIGHT_BIN"
  PLAYWRIGHT_ARGS="[\"--headless\"]"
else
  PLAYWRIGHT_CMD="$NPX_PATH"
  PLAYWRIGHT_ARGS="[\"-y\", \"@playwright/mcp\", \"--headless\"]"
fi

if [ -f "$FILESYSTEM_BIN" ] && [ "$FILESYSTEM_BIN" != "$NPX_PATH" ]; then
  FILESYSTEM_CMD="$FILESYSTEM_BIN"
  FILESYSTEM_ARGS="[\"$HOME/spendesk-workshop\"]"
else
  FILESYSTEM_CMD="$NPX_PATH"
  FILESYSTEM_ARGS="[\"-y\", \"@modelcontextprotocol/server-filesystem\", \"$HOME/spendesk-workshop\"]"
fi

cat > "$CLAUDE_DESKTOP_CONFIG" << MCPEOF
{
  "mcpServers": {
    "supabase": {
      "command": "$SUPABASE_CMD",
      "args": $SUPABASE_ARGS
    },
    "playwright": {
      "command": "$PLAYWRIGHT_CMD",
      "args": $PLAYWRIGHT_ARGS
    },
    "filesystem": {
      "command": "$FILESYSTEM_CMD",
      "args": $FILESYSTEM_ARGS
    }
  }
}
MCPEOF

echo -e "${GREEN}  ✓ Claude Desktop configured${NC}"

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
