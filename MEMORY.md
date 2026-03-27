# MEMORY.md - Long-Term Memory

*Last updated: (auto-updated by your agent)*

<!--
This is your agent's curated long-term memory.
It builds this up over time as it learns about you, your projects, and your preferences.
Think of it as a distilled journal — wisdom, not raw logs.
-->

## Memory Categories & Token Impact

**Important:** the `instruction` category auto-injects into EVERY message. Keep it lean.

| Category | Auto-injected? | Use for |
|----------|----------------|---------|
| `instruction` | **yes, every message** | Universal rules only (style, tone, core behavior) |
| `context` | No, searched on-demand | Project patterns, API syntax, guardrails |
| `fact` | No, searched on-demand | Personal info, dates, preferences |
| `decision` | No, searched on-demand | Architectural choices, why things were built a certain way |
| `entity` | No, searched on-demand | People, services, accounts |
| `relationship` | No, searched on-demand | Connections between people or things |

**Target:** 4-5 instruction memories max (~200 tokens total). Everything else goes in context/fact/decision.

## Sections (filled in by your agent over time)

### About You
<!-- Your preferences, work style, communication habits -->

### Projects
<!-- Architectures, key decisions, gotchas worth remembering -->

### Bugs Fixed
<!-- Important issues so they don't resurface -->

### Rules & Lessons
<!-- Things learned the hard way — standing rules -->

---

## Nightly Memory Consolidation

Your agent improves its memory overnight. A nightly consolidation job (2am) does four things:

1. **Extract unsaved context** — reviews the day's conversations for decisions, preferences, and corrections not yet stored
2. **Clean stale memories** — removes or updates memories that are no longer accurate
3. **Review MISTAKES.md** — checks the error log and ensures every entry has a prevention rule in memory
4. **Write a summary** — saves a consolidation report to `memory/consolidation-YYYY-MM-DD.md`

### Setting up consolidation

```bash
# Nightly consolidation (2am)
openclaw cron add "nightly-consolidation" \
  --schedule "0 2 * * *" \
  --prompt "Review today's conversations. Extract any unsaved decisions, preferences, or corrections into memory. Clean up stale memories. Check MISTAKES.md for entries missing prevention rules. Write a summary to memory/consolidation-$(date +%Y-%m-%d).md."

# Optional: weekly deep cleanup (Sundays at 3am)
openclaw cron add "weekly-memory-cleanup" \
  --schedule "0 3 * * 0" \
  --prompt "Deep review of all memories. Deduplicate, merge related entries, archive anything older than 90 days that hasn't been accessed. Update MEMORY.md sections."
```

The consolidation job compounds over time — decisions made on Monday are searchable context by Tuesday morning.

## MISTAKES.md — Learning from Errors

Your agent keeps `MISTAKES.md` at the workspace root. When something goes wrong, it logs the root cause and a standing rule.

The nightly consolidation cross-references each entry with stored memories to make sure every mistake has a prevention rule in place. The loop: mistake happens → gets logged → consolidation creates a rule → agent doesn't repeat it.
