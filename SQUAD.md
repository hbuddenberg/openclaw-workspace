# SQUAD.md - Multi-Agent Setup Guide

Your agent doesn't have to work alone. Set up a squad of specialized agents that your main coordinator delegates to.

## The Pattern

```
YOU (human)
  ↕
COORDINATOR (main agent — your direct line)
  ↕                ↕               ↕
CONTENT AGENT    DEV AGENT    RESEARCH AGENT
(content, posts) (code, ops)  (analytics, intel)
```

You talk to the coordinator. The coordinator delegates to the squad. Results flow back up to you.

## Agent Workspaces

Each agent gets their own folder with its own personality and working files:

```
~/.openclaw/
├── AGENTS.md              ← coordinator's operating manual
├── SOUL.md                ← coordinator's personality
├── agents/
│   ├── content-agent/
│   │   ├── SOUL.md        ← content agent's personality + rules
│   │   └── WORKING.md     ← drafts awaiting human approval
│   ├── dev-agent/
│   │   ├── SOUL.md        ← dev agent's personality + rules
│   │   └── TICK.md        ← activity log (keep it trimmed)
│   └── research-agent/
│       ├── SOUL.md        ← research agent's personality + rules
│       └── FINDINGS.md    ← research reports
└── ops/
    ├── policies.json          ← what auto-approves vs needs human approval
    └── reaction-matrix.json   ← how agents trigger each other
```

## Setting Up Agents in OpenClaw

Each agent runs as a separate OpenClaw agent with its own heartbeat schedule:

```yaml
# In your openclaw.json config:
agents:
  content-agent:
    model: anthropic/claude-sonnet-4-20250514
    workspace: ./agents/content-agent
    heartbeat:
      interval: 30m
  dev-agent:
    model: anthropic/claude-sonnet-4-20250514
    workspace: ./agents/dev-agent
    heartbeat:
      interval: 15m
  research-agent:
    model: anthropic/claude-sonnet-4-20250514
    workspace: ./agents/research-agent
    heartbeat:
      interval: 2h
```

## Policies (ops/policies.json)

Controls what agents can do autonomously vs what requires a human decision:

- **auto_approve_rules** — low-risk tasks that don't need approval (research, analysis, health checks)
- **require_approval** — always ask before doing these (tweets, emails, deploys)
- **never_auto_approve** — hard stops (deleting things, pushing to production)
- **caps** — daily limits (max tweets, DMs, emails per day)
- **work_hours** — agents only work within these hours

## Reaction Matrix (ops/reaction-matrix.json)

This is where emergent behavior happens — agents triggering other agents based on events:

- Content agent posts something → research agent analyzes engagement after 1 hour
- Dev agent finds a bug → coordinator alerts you immediately
- Research agent spots high engagement → content agent drafts a follow-up
- Any mission fails → dev agent runs diagnostics

Each reaction has:
- **probability** — doesn't always fire (keeps behavior from feeling mechanical)
- **cooldown** — prevents spam loops
- **delay** — some reactions should wait before acting

## Tips

- **Start with one agent.** Add more when you actually need them.
- **Trim activity logs weekly.** Dev agent's TICK.md will bloat fast.
- **Content agent never posts without approval.** Non-negotiable.
- **Use cheaper models for sub-agents.** Save your best model for the coordinator.
- **Agents communicate through files.** WORKING.md, FINDINGS.md, TICK.md — that's their shared memory.

## Delegation Examples

**"Draft a tweet about our new feature"**
→ Coordinator sends task to content agent
→ Content agent drafts in WORKING.md
→ Coordinator surfaces it for your approval
→ You approve → it gets posted

**"Is production healthy?"**
→ Coordinator delegates to dev agent
→ Dev agent checks CI, error rates, uptime
→ Reports back through coordinator with findings

**"What are competitors doing this week?"**
→ Coordinator sends task to research agent
→ Research agent scans competitor sites, social, changelogs
→ Files findings in FINDINGS.md
→ Coordinator summarizes for you
