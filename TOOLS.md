# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics — the stuff unique to your setup that no template can know.

## What Goes Here

Things like:
- SSH hosts and aliases
- Camera names and locations (if you use them)
- Preferred voices for TTS
- Speaker or room names for smart home
- Device nicknames
- API quirks you've discovered and want to remember

## Examples

```markdown
### SSH
- home-server → 192.168.1.100, user: admin
- vps-01 → agent.yourdomain.com, user: deploy

### Cameras
- front-door → Entrance cam, motion-triggered
- office → Main workspace, wide angle

### TTS
- Preferred voice: "Nova"
```

## Why Separate?

Skills are shared across setups. Your specifics are yours. Keeping them apart means you can update skills without losing your notes — and share skills without leaking your infrastructure details.

---

## Exa AI Search

OpenClaw 2026.3.22+ includes Exa AI as a built-in web search provider. Exa gives you neural search, keyword search, date filtering, and content extraction — all from the agent.

### Enabling Exa

```bash
# 1. Enable the Exa plugin
openclaw plugins enable exa

# 2. Add your API key to ~/.openclaw/.env
echo "EXA_API_KEY=your-api-key-here" >> ~/.openclaw/.env
```

Then add this to your `openclaw.json`:

```json
{
  "tools": {
    "web": {
      "search": {
        "provider": "exa"
      }
    }
  }
}
```

Once configured, your agent can search the web, fetch page content, and extract highlights through Exa's API. Get an API key at [exa.ai](https://exa.ai).

---

Add whatever helps you do your job. This is your personal cheat sheet.
