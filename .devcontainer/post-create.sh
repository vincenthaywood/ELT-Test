#!/bin/bash
set -e

echo "🚀 Setting up Spendesk Rebuild Workshop environment..."

# ── Dependencies ──────────────────────────────────────────
echo "📦 Installing project dependencies..."
npm install

# ── Playwright browsers ───────────────────────────────────
echo "🎭 Installing Playwright (for site crawling demo)..."
npx playwright install chromium --with-deps 2>/dev/null || echo "⚠ Playwright install skipped"

# ── Claude Code ───────────────────────────────────────────
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code 2>/dev/null || echo "⚠ Claude Code may already be present"

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
        "/workspaces/ELT-Test"
      ]
    }
  }
}
EOF

# ── Env file ──────────────────────────────────────────────
cat > .env.local << 'EOF'
VITE_SUPABASE_URL=https://beafagckgeidshnoikzg.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs
EOF

# ── Welcome message ───────────────────────────────────────
cat >> ~/.bashrc << 'EOF'

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   🚀 Spendesk Rebuild Workshop               ║"
echo "║                                              ║"
echo "║   1. claude login  (first time only)         ║"
echo "║   2. claude        (start building!)         ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
EOF

echo ""
echo "✅ Environment ready!"
echo "   → Type: claude login  (if first time)"
echo "   → Then: claude"
echo ""
