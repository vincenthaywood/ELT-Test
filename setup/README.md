# Workshop Setup

## Mac

Open **Terminal** (press Cmd+Space, type Terminal, hit Enter) and paste this:

```
curl -fsSL https://raw.githubusercontent.com/vincenthaywood/ELT-Test/main/setup/mac-setup.sh | bash
```

It will ask which team you're on, then do everything automatically.
Takes about 2 minutes.

---

## Windows

1. Download and unzip the workshop folder
2. Open the `setup` folder
3. Double-click **`windows-setup.bat`**
4. If Windows Defender appears: More info → Run anyway

---

## What it does
- Checks Node.js is installed
- Installs Claude Code
- Asks which team you're on
- Configures the workshop database connection
- Downloads the workshop files
- Opens a live preview at **http://localhost:5173**
- Copies your first prompt to clipboard
- Logs you in with your claude.ai account

## On the day
1. Open **Claude Desktop**
2. Press **Cmd+V** (Mac) or **Ctrl+V** (Windows) to paste your first prompt
3. Watch the preview at **http://localhost:5173** update in real time

## Problems?
Screenshot the terminal and send to Vincent on Slack.
