# Multi-Machine OpenClaw Mesh

Run multiple OpenClaw agents across machines that can talk to each other — useful when you want to distribute compute, isolate workloads, or give each agent its own identity.

## Architecture

```
┌─────────────────────┐     tailscale      ┌─────────────────────┐
│   Machine #1        │◄──────────────────►│   Machine #2        │
│   "main"            │    100.x.x.x       │   "forge"           │
│                     │                     │                     │
│   • messaging       │                     │   • heavy compute   │
│   • coordinator     │   chat.send (SSH)   │   • build tasks     │
│   • main agent      │◄──────────────────►│   • research jobs   │
│   • notifications   │   webhook hooks     │   • background work │
└─────────────────────┘                     └─────────────────────┘
```

## Setup

### Prerequisites
- Both machines on the same Tailscale network
- Generate a pre-auth key at https://login.tailscale.com/admin/settings/keys

### Machine 1 (already running)
1. Make sure Tailscale is connected:
   ```bash
   tailscale up --hostname=openclaw-main
   tailscale ip -4  # note this IP
   ```

2. Enable Tailscale mode in openclaw config:
   ```json
   "gateway": {
     "tailscale": { "mode": "on" }
   }
   ```

### Machine 2 (new)
```bash
# Bootstrap with one command:
./bootstrap-mac.sh \
  --identity forge \
  --tailscale-key tskey-auth-xxxxx \
  --peer http://100.x.x.x:18789 \
  --alert +1XXXXXXXXXX
```

### Accounts & Identity

| Thing | Same or Separate? | Why |
|-------|-------------------|-----|
| OS user account | **separate** | Clean isolation, own keychain |
| Apple ID (if Mac) | **separate** | Own iCloud, own iMessage number |
| GitHub | **same** (deploy key per repo) | Access same repos, separate SSH keys |
| Anthropic API | **same account** | One bill, separate API keys |
| Tailscale | **same network** | They need to reach each other |
| OpenClaw license | **separate install** | Each gateway is independent |

### Cross-Gateway Communication

Once both machines are on Tailscale, they can talk to each other.

#### True Compute Delegation (recommended)

Use `chat.send` via SSH to run AI compute on the remote machine:

```bash
ssh forge@100.x.x.x "openclaw gateway call chat.send \
  --token '<forge-gateway-token>' \
  --params '{
    \"sessionKey\": \"agent:main:main\",
    \"message\": \"run the test suite on your-app repo\",
    \"idempotencyKey\": \"task-$(date +%s)\"
  }'"
```

This runs AI inference on forge's hardware using forge's auth. The compute is genuinely delegated.

#### What Does NOT Delegate Compute

`sessions_spawn` with `gatewayUrl` does NOT run compute remotely. It still runs locally. Don't use it for true delegation.

#### Other Communication Methods

1. **Webhook hooks**: configure hooks to POST to peer gateway on events
2. **Shared workspace via git**: both agents push/pull from the same repos

### OAuth Token Sync Between Machines

If both machines use Claude Code with OAuth (flat-rate subscription), tokens need syncing. They live at:

```
~/.claude/.credentials.json
```

Claude Code handles its own token refresh internally. Don't call the OAuth refresh endpoint directly (you'll hit rate limits). Instead:

1. Run `claude -p 'ok'` to force an internal token refresh
2. Read the fresh tokens from `~/.claude/.credentials.json`
3. Copy them to wherever your agent needs them

Example sync script (run as a cron every 2 hours):
```bash
#!/bin/bash
# sync-oauth-tokens.sh
# force claude to refresh, then copy tokens to openclaw auth profile

claude -p 'ok' 2>/dev/null  # triggers internal refresh
CREDS="$HOME/.claude/.credentials.json"
if [ -f "$CREDS" ]; then
    cp "$CREDS" "$HOME/.openclaw/auth-profiles.json"
    echo "[$(date)] tokens synced"
fi
```

**Note:** if you run agents on separate accounts (recommended), each machine has its own tokens. Keep them separate — don't copy tokens between machines.

### Setup Gotchas

1. **Device pairing**: the remote machine must approve the calling machine's device pairing first
2. **Trusted proxies**: add the calling machine to `trustedProxies` in the remote machine's config
3. **Auth profiles**: the remote machine's `auth-profiles.json` needs both access AND refresh token fields for auto-refresh to work
4. **Token expiry**: set up the sync script as a cron to avoid overnight token death

### Security
- Gateway tokens are per-machine and never shared
- Tailscale handles encryption + auth between machines
- Each agent has its own memory store (no cross-contamination)
- Peer communication goes through authenticated gateway endpoints
