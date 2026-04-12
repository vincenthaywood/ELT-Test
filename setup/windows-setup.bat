@echo off
setlocal enabledelayedexpansion
title Spendesk Workshop Setup

cls
echo ============================================
echo    Spendesk Rebuild Workshop - Windows Setup
echo ============================================
echo.

:: ── Step 1: Check Node.js ──────────────────────────────
echo Step 1 of 4 - Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo   [X] Node.js not found.
    echo.
    echo   Please install it first:
    echo   1. Go to https://nodejs.org
    echo   2. Click the big green LTS button
    echo   3. Run the installer
    echo   4. Double-click this setup file again
    echo.
    start https://nodejs.org
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do set NODE_VER=%%i
echo   [OK] Node.js found (%NODE_VER%)

:: ── Step 2: Install Claude Code ───────────────────────
echo.
echo Step 2 of 4 - Installing Claude Code...
claude --version >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] Claude Code already installed
) else (
    echo   Installing Claude Code (takes ~30 seconds)...
    call npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 (
        echo   [X] Install failed. Try running as Administrator.
        pause
        exit /b 1
    )
    echo   [OK] Claude Code installed
)

:: ── Step 3: Login ──────────────────────────────────────
echo.
echo Step 3 of 4 - Logging in to Claude...
echo.
echo   A browser window will open.
echo   Sign in with your usual claude.ai account.
echo.
pause
claude login
echo   [OK] Claude login complete

:: ── Step 4: Configure MCPs ─────────────────────────────
echo.
echo Step 4 of 4 - Configuring workshop tools...

if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude"

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
echo       "args": ["-y", "@modelcontextprotocol/server-filesystem", "%USERPROFILE%\\spendesk-workshop"]
echo     }
echo   }
echo }
) > "%USERPROFILE%\.claude\settings.json"

echo   [OK] Workshop tools configured

:: ── Step 5: Workshop folder ────────────────────────────
echo.
echo Setting up workshop folder...
set WORKSHOP_DIR=%USERPROFILE%\spendesk-workshop
if not exist "%WORKSHOP_DIR%" mkdir "%WORKSHOP_DIR%"
xcopy /E /I /Y "%~dp0.." "%WORKSHOP_DIR%" >nul 2>&1
cd /d "%WORKSHOP_DIR%"
call npm install --silent >nul 2>&1
echo   [OK] Workshop folder ready at %WORKSHOP_DIR%

:: ── Done ───────────────────────────────────────────────
echo.
echo ============================================
echo    All done - you're ready for the workshop!
echo ============================================
echo.
echo   On the day, Vincent will tell you which
echo   team you're on and what to type.
echo.
echo   Your workshop folder is at:
echo   %USERPROFILE%\spendesk-workshop
echo.
pause
