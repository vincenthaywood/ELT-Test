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

:: ── Node.js ───────────────────────────────────────────────
echo [1/5] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo   X  Node.js not found.
    echo   Go to https://nodejs.org, install it, restart, then run this again.
    start https://nodejs.org
    pause & exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do echo   OK  Node.js %%v

:: ── Claude Code ──────────────────────────────────────────────
echo.
echo [2/5] Installing Claude Code...
claude --version >nul 2>&1
if %errorlevel% equ 0 (
    echo   OK  Already installed
) else (
    call npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 ( echo   X  Failed. Try right-click Run as Administrator & pause & exit /b 1 )
    echo   OK  Installed
)

:: ── Team selection ──────────────────────────────────────────
echo.
echo [3/5] Which team are you on?
echo.
echo   1) Cards
echo   2) Expenses
echo   3) Approvals
echo   4) Analytics
echo   5) Budgets
echo   6) Procurement
echo.
set /p TEAM_NUM=  Enter number (1-6): 

if "%TEAM_NUM%"=="1" ( set TEAM_DIR=team-cards&      set TEAM_NAME=Cards )
if "%TEAM_NUM%"=="2" ( set TEAM_DIR=team-expenses&    set TEAM_NAME=Expenses )
if "%TEAM_NUM%"=="3" ( set TEAM_DIR=team-approvals&   set TEAM_NAME=Approvals )
if "%TEAM_NUM%"=="4" ( set TEAM_DIR=team-analytics&   set TEAM_NAME=Analytics )
if "%TEAM_NUM%"=="5" ( set TEAM_DIR=team-budgets&     set TEAM_NAME=Budgets )
if "%TEAM_NUM%"=="6" ( set TEAM_DIR=team-procurement& set TEAM_NAME=Procurement )

if not defined TEAM_DIR ( echo   X  Invalid choice & pause & exit /b 1 )
echo   OK  Team %TEAM_NAME% selected

:: ── MCP config ───────────────────────────────────────────────
echo.
echo [4/5] Configuring workshop tools...
set WORKSHOP=%USERPROFILE%\spendesk-workshop
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
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-filesystem",
echo         "%WORKSHOP%\%TEAM_DIR%"
echo       ]
echo     }
echo   }
echo }
) > "%USERPROFILE%\.claude\settings.json"
echo   OK  Tools configured (filesystem locked to your team folder)

:: ── Workshop folder ─────────────────────────────────────────
echo.
echo [5/5] Downloading workshop files...
if exist "%WORKSHOP%\.git" (
    cd /d "%WORKSHOP%" && git pull --quiet
) else (
    git clone https://github.com/vincenthaywood/ELT-Test.git "%WORKSHOP%"
)
cd /d "%WORKSHOP%"
call npm install --silent >nul 2>&1
echo   OK  Workshop files ready

:: ── Dev server + browser ───────────────────────────────────
start /b cmd /c "cd /d %WORKSHOP% && npm run dev"
timeout /t 4 /nobreak >nul
start http://localhost:5173
echo   OK  Live preview opened at localhost:5173

:: ── Copy first prompt to clipboard ─────────────────────────
set FIRST_PROMPT=Read the file at %WORKSHOP%\%TEAM_DIR%\CLAUDE.md and then let's start building the %TEAM_NAME% module.
echo %FIRST_PROMPT% | clip
echo   OK  First prompt copied to clipboard -- just paste it into Claude Desktop

:: ── Login ───────────────────────────────────────────────────
echo.
echo Almost done! Sign in to Claude.
echo A browser tab will open -- use your usual claude.ai account.
echo.
pause
claude login

:: ── Done ───────────────────────────────────────────────────
cls
echo.
echo   +==========================================+
echo   ^|   You're all set for the workshop!       ^|
echo   +==========================================+
echo.
echo   Team:    %TEAM_NAME%
echo   Folder:  %WORKSHOP%\%TEAM_DIR%
echo   Preview: http://localhost:5173
echo.
echo   On the day:
echo   1. Open Claude Desktop
echo   2. Paste your first prompt (already in clipboard!)
echo   3. Watch the preview update as Claude builds
echo.
pause
