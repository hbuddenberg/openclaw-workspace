# Token Optimization Guide

How to stretch your Claude Max (or any LLM subscription) significantly further.

## The Problem

Every message you send includes:
- All previous messages in the conversation (context window)
- All auto-injected instructions (memory category: `instruction`)
- System prompts, tool definitions, and file contents read during the session

A 50-message conversation might be sending 100k+ tokens per message. That's why a $200/month plan burns out in 2-3 days.

## Quick Wins (free, immediate)

### 1. Minimize auto-injected instructions

OpenClaw's memory-tools plugin auto-injects every memory with `category: instruction` into every single message. Each instruction burns tokens on every exchange.

**Rules:**
- Only store truly universal rules as `instruction` (style, tone, core behavior)
- Store everything else as `context` (searched on-demand, not auto-injected)
- Target: 4-5 instruction memories max, ~200 tokens total

**Good instruction memories** (needed in every message):
- Writing style / tone preferences
- Core delegation rules
- Communication preferences

**Bad instruction memories** (move these to context):
- API syntax and patterns (only needed when using that API)
- Project-specific guardrails (only needed when working on that project)
- Reference templates (only needed when writing that type of content)

### 2. Reset conversations often

Context grows linearly with conversation length. Message 50 carries all 49 previous messages.

| Conversation length | Approx tokens/message | Waste factor |
|---------------------|----------------------|--------------|
| 5 messages          | ~5k                  | 1x (baseline) |
| 20 messages         | ~30k                 | 6x |
| 50 messages         | ~80k                 | 16x |
| 100 messages        | context limit hit    | compaction kicks in |

**Rule of thumb:** start a new conversation when switching topics. One focused 10-message thread beats a sprawling 50-message one.

### 3. Read files efficiently

Use `Read` with `offset` and `limit` instead of loading entire files. A 500-line file read once stays in context for the rest of the session.

### 4. Batch your questions

5 separate messages = 5 full context sends. One message with 5 questions = 1 context send.

## Multi-Machine Delegation

If you have two machines (e.g. main agent + secondary forge), route tasks by complexity:

| Task type | Where to run | Why |
|-----------|-------------|-----|
| Quick answers, conversation | Primary | Low tokens, fast |
| Code generation | Secondary (forge) | High tokens, delegated |
| Web research | Secondary (forge) | Fetching adds to context |
| File analysis | Secondary (forge) | Large content in context |
| Local file edits | Primary | Needs filesystem access |

Delegation via SSH:
```bash
ssh agent-2@<tailscale-ip> "openclaw gateway call chat.send \
  --token '<gateway-token>' \
  --params '{\"sessionKey\": \"agent:main:main\", \"message\": \"<task>\", \"idempotencyKey\": \"<unique-id>\"}'"
```

**Important:** `sessions_spawn` with `gatewayUrl` does NOT delegate compute. It still runs locally. Use `chat.send` via SSH for true remote delegation.

## Memory Hygiene

Audit your instruction memories periodically:

```bash
# Check how many instruction memories exist
sqlite3 ~/.openclaw/memory/tools/memory.db \
  "SELECT COUNT(*) FROM memories WHERE category = 'instruction';"
```

Target: 4-5 instruction memories, everything else as context/fact/decision.

## Session Auto-Reset

Configure your agent to proactively suggest session resets when context exceeds 50%. This prevents the worst token waste from long-running mega-conversations.
