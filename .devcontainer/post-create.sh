#!/bin/bash
set -e

echo "🚀 Setting up Spendesk Rebuild Workshop environment..."

# ── Dependencies ──────────────────────────────────────────
echo "📦 Installing project dependencies..."
npm install

# ── Playwright browsers ───────────────────────────────────
echo "🎭 Installing Playwright (for site crawling demo)..."
npx playwright install chromium --with-deps 2>/dev/null || echo "⚠ Playwright install skipped — will retry on first use"

# ── Claude Code ───────────────────────────────────────────
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code 2>/dev/null || echo "⚠ Claude Code install skipped — may already be present"

# ── MCP config ────────────────────────────────────────────
echo "🔌 Configuring MCP servers..."
mkdir -p ~/.claude

cat > ~/.claude/settings.json << 'EOF'
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--supabase-url", "SUPABASE_URL_PLACEHOLDER",
        "--supabase-api-key", "SUPABASE_KEY_PLACEHOLDER"
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
        "/workspaces/ELT-Test"
      ]
    }
  }
}
EOF

# ── Env file ──────────────────────────────────────────────
if [ ! -f .env.local ]; then
  cat > .env.local << 'EOF'
VITE_SUPABASE_URL=SUPABASE_URL_PLACEHOLDER
VITE_SUPABASE_ANON_KEY=SUPABASE_KEY_PLACEHOLDER
EOF
  echo "⚠  .env.local created — add real Supabase credentials before workshop"
fi

# ── Welcome message ───────────────────────────────────────
cat >> ~/.bashrc << 'EOF'

# Workshop welcome
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   🚀 Spendesk Rebuild Workshop               ║"
echo "║                                              ║"
echo "║   Type: claude                               ║"
echo "║   Then: Read CLAUDE.md and let's build!      ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
EOF

echo ""
echo "✅ Workshop environment ready!"
echo "   → Open a terminal and type: claude"
echo ""
