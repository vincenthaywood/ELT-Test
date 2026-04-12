@echo off
setlocal enabledelayedexpansion
title Spendesk Workshop Setup
cd /d "%~dp0"
cls

echo.
echo   +==========================================+
echo   ^|   Spendesk Workshop -- Windows Setup     ^|
echo   +==========================================+
echo.

:: ── Node.js check ────────────────────────────────────────────
echo [1/4] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo   X  Node.js not found.
    echo.
    echo   Please install it first:
    echo   1. Go to https://nodejs.org
    echo   2. Click the big LTS button and run the installer
    echo   3. Restart your computer
    echo   4. Double-click this file again
    echo.
    start https://nodejs.org
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do echo   OK  Node.js %%v

:: ── Claude Code ──────────────────────────────────────────────
echo.
echo [2/4] Installing Claude Code...
claude --version >nul 2>&1
if %errorlevel% equ 0 (
    echo   OK  Already installed
) else (
    echo   Installing... (takes about 30 seconds)
    call npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 (
        echo   X  Install failed.
        echo   Try right-clicking this file and selecting Run as Administrator
        pause
        exit /b 1
    )
    echo   OK  Claude Code installed
)

:: ── MCP config ───────────────────────────────────────────────
echo.
echo [3/4] Configuring workshop tools...
if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude"

>>"%USERPROFILE%\.claude\settings.json" echo {}
type nul > "%USERPROFILE%\.claude\settings.json"

(
echo {
echo   "mcpServers": {
echo     "supabase": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@supabase/mcp-server-supabase@latest",
echo         "--supabase-url", "https://beafagckgeidshnoikzg.supabase.co",
echo         "--supabase-api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs"
echo       ]
echo     },
echo     "playwright": {
echo       "command": "npx",
echo       "args": ["-y", "@playwright/mcp@latest", "--headless"]
echo     },
echo     "filesystem": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-filesystem",
echo         "%USERPROFILE%\spendesk-workshop"
echo       ]
echo     }
echo   }
echo }
) > "%USERPROFILE%\.claude\settings.json"
echo   OK  Supabase, Playwright and Filesystem configured

:: ── Workshop folder ──────────────────────────────────────────
echo.
echo [4/4] Setting up your workshop folder...
set WORKSHOP=%USERPROFILE%\spendesk-workshop

if exist "%WORKSHOP%\.git" (
    echo   Updating existing workshop folder...
    cd /d "%WORKSHOP%"
    git pull --quiet
) else (
    echo   Downloading workshop files...
    git clone https://github.com/vincenthaywood/ELT-Test.git "%WORKSHOP%" 2>nul
)

cd /d "%WORKSHOP%"
call npm install --silent >nul 2>&1
echo   OK  Workshop folder ready

:: ── Start dev server ─────────────────────────────────────────
echo.
echo   Starting live preview...
start /b cmd /c "cd /d %WORKSHOP% && npm run dev"
timeout /t 4 /nobreak >nul
start http://localhost:5173
echo   OK  Preview opened at localhost:5173

:: ── Login ────────────────────────────────────────────────────
echo.
echo Almost done! Just need to log in to Claude.
echo.
echo   A browser tab will open -- sign in with your claude.ai account.
echo.
pause
cd /d "%WORKSHOP%"
claude login

:: ── Done ────────────────────────────────────────────────────
echo.
echo   +==========================================+
echo   ^|   All done! You're ready for the        ^|
echo   ^|   workshop. See you on May 6th!          ^|
echo   +==========================================+
echo.
echo   Your live preview: http://localhost:5173
echo.
echo   On the day Vincent will tell you:
echo   - Which team you're on
echo   - What to type into Claude Desktop
echo.
pause
