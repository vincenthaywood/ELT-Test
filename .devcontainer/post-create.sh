#!/bin/bash

echo "🚀 Setting up Spendesk Rebuild Workshop..."

# ── Dependencies ──────────────────────────────────────────
echo "📦 Installing project dependencies..."
npm install --silent

# ── Claude Code ───────────────────────────────────────────
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code --silent 2>/dev/null || echo "⚠ Claude Code install issue — try: npm install -g @anthropic-ai/claude-code"

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

# ── Playwright — install in background, don't block ───────
echo "🎭 Installing Playwright in background (non-blocking)..."
(npx playwright install chromium 2>/dev/null && echo "✅ Playwright ready") &

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
echo "✅ Workshop environment ready!"
echo "   → Type: claude login"
echo "   → Then: claude"
echo ""
