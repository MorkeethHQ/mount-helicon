# Mount Helicon — 90-Second Demo (shot-list + spoken script)

**North star:** the verifier with a memory.
**The case:** *not renames — full tracking of a real, context-intensive, ever-changing board.* One builder, ~15 live projects, four years of agent memory, six sources. Watch Helicon hold that memory **true** across every kind of drift, and make a correction **stick forever**.
**Punchline (everything builds to it):** *A store forgets it ever asked. Helicon remembers what you ruled.*
**Rule:** one on-screen moment per beat. Nothing said that isn't shown. Zero fake data — every frame is a real command on Oscar's real store (5,705 memories). All examples are projects, not personal life.

Total: **6 beats, ≤90s.** VO ≈ 210 words.

> **This demo now runs end-to-end for real** (fixed Jul 13): the loop is `audit --file → resolve --list → resolve → audit → recurrence`. See "What changed" at the bottom.

---

## THE SPINE — three real commands, your real board

```
helicon audit                                  # the exam: 12 classes, 6 rotting, live
helicon alias                                  # FAVOUR: one project's full lifecycle tracked
helicon audit --file && helicon resolve --list # what needs ruling, incl. the Yieldbound fork
helicon resolve 348 --truth "a yield treasury" # rule once → becomes law
helicon audit                                  # the ruling stuck
# …a new note re-asserts the old definition → re-alarm (never-twice)
```

---

## SHOT LIST

| # | t | ON SCREEN (one moment) | SPOKEN (VO) | On-screen text |
|---|-----|------------------------|-------------|----------------|
| 1 | 0:00–0:16 | `helicon audit` runs; the 12-class scorecard fills in; cursor rests on `6/12 classes show rot right now · 5,705 memories` | "I run fifteen projects. My agents have four years of memory about all of them, across six tools. I can't remember which memory is still true — and neither can they. One command exams the whole board. Six kinds of rot, live." | `whole board · 5,705 memories · 6 sources` |
| 2 | 0:16–0:36 | `helicon alias` → the RELAY→FAVOUR block: `500 current-claim leaks`, the history/rename-aware/current-claims split, `0/5 top-K for FAVOUR` | "Here's one project, tracked end to end. I renamed Relay to FAVOUR eleven days ago. Five hundred memories still assert the dead name — and Helicon separates the hundred that were *true when written* from the five hundred that are now just wrong. My agent retrieves zero for the real name." | `FAVOUR: 500 stale claims, 0/5 retrieval` |
| 3 | 0:36–0:52 | `helicon resolve --list` → the R11 block; highlight `#348 'yieldbound' — treasury vs tracker` | "It's not just names. Two of my notes disagree on what Yieldbound even *is* — a yield treasury in one, a wallet tracker in another. A store kept both and will cite either one tomorrow. Helicon sees the fork." | `is this still true?` |
| 4 | 0:52–1:08 | `helicon resolve 348 --truth "a yield treasury"` → prints the correction cube + Golden Rule; then `helicon audit` → R11 line flips toward CLEAN | "So I rule it. Once. Yieldbound is a yield treasury — the fork loses. And the ruling doesn't just get filed — it compiles into the Golden Rules my agent reads before it writes. Re-audit: settled." | `rule once → it becomes law` |
| 5 | 1:08–1:26 | A new note scrolls in (`Update: Yieldbound is a wallet tracker after all…`); beat of silence; `resolve --list` re-run → `#N 'yieldbound' RE-ALARM` in red | "Then a new memory sneaks the old definition back in. A store would just save it. Watch. Re-alarm — the instant a settled verdict is contradicted, it fires again. A store forgets it ever asked. Helicon remembers what I ruled." | `never twice` |
| 6 | 1:26–1:30 | Logline card on black | "Memory stores remember. Mount Helicon judges what's still true. The verifier — with a memory." | `Mount Helicon` |

---

## CONTINUOUS SPOKEN SCRIPT (~210 words)

> I run fifteen projects. My agents have four years of memory about all of them, across six tools — and I can't remember which of it is still true. Neither can they. One command exams the whole board. **Six kinds of rot, live.**
>
> Here's one project, tracked end to end. I renamed Relay to FAVOUR eleven days ago. **Five hundred** memories still assert the dead name — and Helicon separates the hundred that were *true when written* from the five hundred that are now just wrong. My agent retrieves **zero** for the real name.
>
> And it's not just names. Two of my notes disagree on what Yieldbound even *is* — a yield treasury in one, a wallet tracker in another. A store kept both and will cite either one. **Helicon sees the fork.**
>
> So I rule it. Once. Yieldbound is a yield treasury — the fork loses. The ruling compiles into the **Golden Rules** my agent reads before it writes. Re-audit: settled.
>
> Then a new memory sneaks the old definition back in. A store would just save it. Watch. **Re-alarm.** A store forgets it ever asked. **Helicon remembers what I ruled.**
>
> Memory stores remember. Mount Helicon judges what's still true. The verifier — with a memory.

---

## HOW TO CAPTURE (one sitting, repeatable)

**Demo on a COPY so takes are repeatable** (ruling writes to the store):
```bash
cp data/helicon.db /tmp/demo.db
export HELICON_DB=/tmp/demo.db          # or point config.json db_path at the copy
# re-copy between takes to reset to the un-ruled state
```

**Terminal setup:** dark theme, ≥18pt, narrow window (no wrap), clean prompt. Pre-run once to warm the embedding model, then screen-record a clean replay. Type nothing on camera.

- **Beat 1** — `helicon audit`. Real: `6/12 classes show rot`, 5,705 memories. Read-only.
- **Beat 2** — `helicon alias`. Real: RELAY→FAVOUR `500 current-claims`, `0/5 top-K for FAVOUR`. Read-only. This is the "full lifecycle of one project" beat — the history/rot split is the impressive part.
- **Beat 3** — `helicon audit --file` (files findings) then `helicon resolve --list`. Real `#348 yieldbound treasury/tracker`. (The finding ID may differ on your copy — read it off `resolve --list`.)
- **Beat 4** — `helicon resolve <id> --truth "a yield treasury"`, then `helicon audit` (R11 drops yieldbound). Then `helicon policy --show` if you want the Golden Rule on screen.
- **Beat 5** — append one cube re-asserting the tracker definition, re-run `helicon resolve --list` (or `helicon audit`): yieldbound re-alarms as `resurfaced`. `scripts/demo_reset.py` / `demo_seed.py` can stage this cleanly.

**Edit rhythm:** hard cuts between commands. Hold 1.5s on the Beat-5 re-alarm before the logline. Music drops for the silence before the re-alarm.

---

## What changed (Jul 13 — the fixes that made this demo real)

The mock Aurora demo hid three bugs that broke "use it yourself." All fixed, 183 tests green:

1. **Fake data was polluting the real audit.** A transcript captured `scripts/demo_mem0_audit.py`, so R12 "helios→solana" was Helicon detecting its own demo file. Added a fixture-path guard to the Claude Code connector; retired 73 fixture-capture cubes. R12 is now honestly CLEAN.
2. **R11 was both over- and under-reporting.** The exam used the fast genus-only path (false positives); the rule path used semantic confirmation that compared *full sentences* ("Yieldbound is a…"), whose shared subject inflated similarity and **buried real forks** (0.87 vs 0.31 subject-stripped). Fixed the gate to compare definitions; unified the exam on the semantic-confirmed set. Yieldbound is now a real, rulable finding.
3. **The loop wasn't discoverable.** `resolve --list` only showed R1. Now it surfaces R1 + R11 + R12 with the right verb each, and `helicon audit --file` files findings without a full `evolve` — so the whole rule→law→never-twice loop runs from three commands.

**Honest limit:** no single project trips all 12 classes, so the "ultimate case" is *whole-board breadth* (Beat 1) + *one project's full lifecycle* (FAVOUR, Beat 2) + *the moat* (Yieldbound, Beats 3–5) — not one project hitting every class. That would be fake.
