# Mount Helicon — 90-Second Demo (shot-list + spoken script)

**North star:** the verifier with a memory.
**The case:** *not renames — full tracking of a real, context-intensive, ever-changing board.* One builder, ~15 live projects, two years of agent memory, four sources. Watch Helicon hold that memory **true** across every kind of drift, and make a correction **stick forever**.
**Punchline (everything builds to it):** *A store forgets it ever asked. Helicon remembers what you ruled.*
**Rule:** one on-screen moment per beat. Nothing said that isn't shown. Zero fake data: every frame is a real command on Oscar's real store (~7,000 memories, ~3,800 of them live, on 2026-07-15). All examples are projects, not personal life.

**The numbers below move.** The store grows on every scan, so the counts here are the Jul 15 values, not constants. Capture on the frozen copy (see HOW TO CAPTURE), read the real numbers off that copy, and say those. The VO is written so that honest rounding still matches the screen.

Total: **6 beats, ≤90s.** VO ≈ 210 words.

> **This demo now runs end-to-end for real** (fixed Jul 13): the loop is `audit --file → resolve --list → resolve → audit → recurrence`. See "What changed" at the bottom.

---

## THE SPINE — three real commands, your real board

```
helicon audit                                  # the exam: 12 classes, 6 rotting, live
helicon alias                                  # FAVOUR: one project's full lifecycle tracked
helicon audit --file && helicon resolve --list # what needs ruling, incl. the Yieldbound fork
helicon resolve 355 --truth "a yield treasury" # rule once → becomes law (ID as of Jul 14; read yours off resolve --list)
helicon gold                                   # the ruling compiles into GOLDEN_RULES.md
helicon resolve --list                         # yieldbound gone → settled
# …a new note re-asserts the old definition; helicon audit --file → re-alarm (never-twice)
```

---

## SHOT LIST

| # | t | ON SCREEN (one moment) | SPOKEN (VO) | On-screen text |
|---|-----|------------------------|-------------|----------------|
| 1 | 0:00–0:16 | `helicon audit` runs; the 12-class scorecard fills in; cursor rests on the last line, `6/12 classes show rot right now · 12/12 fully tested, 0 partial` | "I run fifteen projects. My agents have two years of memory about all of them, across four tools. I can't remember which memory is still true, and neither can they. One command exams the whole board. Six kinds of rot, live." | `whole board · ~7,000 memories · 4 sources` |
| 2 | 0:16–0:36 | `helicon alias` → the RELAY→FAVOUR block: `612 live memories still say 'RELAY'`, the history/rename-aware/current-claims split, `0/5 top-K hits for 'FAVOUR'` | "Here's one project, tracked end to end. I renamed Relay to FAVOUR two weeks ago. Six hundred memories still say the dead name. Helicon separates the ninety that were *true when written*, and keeps those, from the three hundred that are current claims and now just wrong. My agent retrieves zero of five for the real name." | `FAVOUR: 329 current-claim leaks, 0/5 retrieval` |
| 3 | 0:36–0:52 | `helicon resolve --list` → the R11 block; highlight `#348 'yieldbound' — treasury vs tracker` | "It's not just names. Two of my notes disagree on what Yieldbound even *is* — a yield treasury in one, a wallet tracker in another. A store kept both and will cite either one tomorrow. Helicon sees the fork." | `is this still true?` |
| 4 | 0:52–1:08 | `helicon resolve 348 --truth "a yield treasury"` → prints the correction cube + Golden Rule; then `helicon audit` → R11 line flips toward CLEAN | "So I rule it. Once. Yieldbound is a yield treasury — the fork loses. And the ruling doesn't just get filed — it compiles into the Golden Rules my agent reads before it writes. Re-audit: settled." | `rule once → it becomes law` |
| 5 | 1:08–1:26 | A new note scrolls in (`Update: Yieldbound is a wallet tracker after all…`); beat of silence; `helicon audit --file` then `resolve --list` re-run → the critical line `#357 [critical] RE-ALARM: 'yieldbound' was ruled 'treasury', but a 'tracker' definition returned (never-twice guard fired)` | "Then a new memory sneaks the old definition back in. A store would just save it. Watch. Re-alarm — the instant a settled verdict is contradicted, it fires again. A store forgets it ever asked. Helicon remembers what I ruled." | `never twice` |
| 6 | 1:26–1:30 | Logline card on black | "Memory stores remember. Mount Helicon judges what's still true. The verifier — with a memory." | `Mount Helicon` |

---

## CONTINUOUS SPOKEN SCRIPT (~210 words)

> I run fifteen projects. My agents have two years of memory about all of them, across four tools, and I can't remember which of it is still true. Neither can they. One command exams the whole board. **Six kinds of rot, live.**
>
> Here's one project, tracked end to end. I renamed Relay to FAVOUR two weeks ago. **Six hundred** memories still say the dead name. Helicon separates the **ninety** that were *true when written*, and keeps those, from the **three hundred** that are current claims and now just wrong. My agent retrieves **zero of five** for the real name.
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

- **Beat 1** — `helicon audit`. Real on Jul 15: `6/12 classes show rot right now · 12/12 fully tested, 0 partial`. Read-only. Note the exam prints no memory count; `helicon doctor` is the command that prints `7003 memories (3827 live, 3176 retired)`, so use that if the overlay needs the number.
- **Beat 2** — `helicon alias`. Real on Jul 15: RELAY→FAVOUR `612 live memories still say 'RELAY'` = `92 history + 191 rename-aware + 329 current-claims`, and `0/5 top-K hits for 'FAVOUR'`. Read-only. This is the "full lifecycle of one project" beat: the history/rot split is the impressive part. Re-read all four numbers off your frozen copy before recording the VO; they move with every scan.
- **Beat 3** — `helicon audit --file` (files findings) then `helicon resolve --list`. Real `#348 yieldbound treasury/tracker`. (The finding ID may differ on your copy — read it off `resolve --list`.)
- **Beat 4** — `helicon resolve <id> --truth "a yield treasury"`, then `helicon audit` (R11 drops yieldbound). Then `helicon policy --show` if you want the Golden Rule on screen.
- **Beat 5** — append one cube re-asserting the tracker definition (dated AFTER the ruling), then `helicon audit --file` and `helicon resolve --list`: yieldbound re-alarms as a distinct `[critical] RE-ALARM: …was ruled 'treasury', but a 'tracker' definition returned (never-twice guard fired)` line — visually different from a first-time fork. `scripts/demo_reset.py` / `demo_seed.py` can stage this cleanly.

**Edit rhythm:** hard cuts between commands. Hold 1.5s on the Beat-5 re-alarm before the logline. Music drops for the silence before the re-alarm.

---

## What changed (Jul 13 — the fixes that made this demo real)

The mock Aurora demo hid three bugs that broke "use it yourself." All fixed, suite green (291 tests on 2026-07-15; `python3 -m pytest tests/ -q` prints today's count, which moves as tests land):

1. **Fake data was polluting the real audit.** A transcript captured `scripts/demo_mem0_audit.py`, so R12 "helios→solana" was Helicon detecting its own demo file. Added a fixture-path guard to the Claude Code connector; retired 73 fixture-capture cubes. R12 is now honestly CLEAN.
2. **R11 was both over- and under-reporting.** The exam used the fast genus-only path (false positives); the rule path used semantic confirmation that compared *full sentences* ("Yieldbound is a…"), whose shared subject inflated similarity and **buried real forks** (0.87 vs 0.31 subject-stripped). Fixed the gate to compare definitions; unified the exam on the semantic-confirmed set. Yieldbound is now a real, rulable finding.
3. **The loop wasn't discoverable.** `resolve --list` only showed R1. Now it surfaces R1 + R11 + R12 with the right verb each, and `helicon audit --file` files findings without a full `evolve` — so the whole rule→law→never-twice loop runs from three commands.

**Honest limit:** no single project trips all 12 classes, so the "ultimate case" is *whole-board breadth* (Beat 1) + *one project's full lifecycle* (FAVOUR, Beat 2) + *the moat* (Yieldbound, Beats 3–5) — not one project hitting every class. That would be fake.
