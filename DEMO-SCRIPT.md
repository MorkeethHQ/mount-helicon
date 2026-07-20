# Mount Helicon — 3-Minute Demo (dashboard walkthrough + spoken script)

> **CANONICAL golden-demo script is [`GOLDEN_SUBMISSION.md`](GOLDEN_SUBMISSION.md)** —
> the one-command `helicon demo` flow on the seeded store (no key, no personal data).
> This file is the longer walkthrough on a real/populated board; use it for the video
> voiceover, but the judge's reproducible path is the golden submission's.

**North star:** the verifier with a memory.
**Punchline (everything builds to it):** *A store forgets it ever asked. Helicon remembers what you ruled.*
**Format:** the **dashboard** (`helicon serve`, browser full-screen), on the author's real store (~8,000 memories, ~3,900 live). Zero fake data — every finding on screen is real rot in a real two-year memory board.
**Rule:** one surface per beat, nothing said that isn't shown.

> **Record on a disposable COPY** so ruling a finding is repeatable and never touches the live store:
> ```bash
> cp data/helicon.db /tmp/record-board.db
> HELICON_CONFIG=<config with db_path=/tmp/record-board.db> helicon serve --port 8421
> # open http://localhost:8421 in the browser, full-screen, dark theme
> ```
> Numbers move on every scan — read the exam's rot count off your own screen and say that, not the number below.

**Total: 5 beats, ~3:00. VO ≈ 300 words.** Five clicks, no terminal.

---

## SHOT LIST (dashboard tabs)

**Beat 1 — "The Exam" tab (0:00–0:30).** The 12-class scorecard, live. Cursor rests on the summary line (`7/12 classes show rot right now · 12/12 fully tested`).
> "I have two years of agent memory — fifteen projects, four tools, almost four thousand live notes. I can't tell you which of it is still true, and neither can my agents. So I built the exam. Twelve ways memory rots, checked live, across the whole board. Right now, seven of twelve are firing. That's not a mock. That's my real memory, failing its own test."

**Beat 2 — "Needs Ruling" tab (0:30–1:25).** Scroll the queue to the identity fork **`'yieldbound' — treasury vs tracker`**. Open the card. Rule it *a yield treasury*. It leaves the queue.
> "Here's what a memory store can't do. Two of my notes disagree on what Yieldbound even *is* — a yield treasury in one, a wallet tracker in another. A store kept both and will cite either one tomorrow. Helicon sees the fork. So I rule it. Once. Yieldbound is a treasury — the other reading loses. And it clears."

**Beat 3 — "Golden Rules" tab (1:25–2:05).** The new ruling sits at the top as compiled law, with its receipt.
> "The ruling doesn't just get filed. It compiles into the Golden Rules my agent reads before it writes — with the receipt. And the instant anything contradicts it, it re-alarms. A store forgets it ever asked. Helicon remembers what I ruled. That's the loop: catch it, rule it, never again."

**Beat 4 — "Memory" tab (2:05–2:35).** The health view: **DEGRADED**, grounding **under half** (~0.39 live — read yours), one task broken.
> "Here's the part most demos hide. Pointed at my own store, my own exam comes back DEGRADED. Grounding under half, one task broken. A system that reports its own weakness is the product. One that shows you a green light is just another benchmark."

**Beat 5 — "Qwen as Judge" tab (2:35–3:00).** Qwen doing the judging, live; then cut to a black tagline card.
> "And every judgment here runs on Qwen — Model Studio for the calls, DashScope for the embeddings. Kill the key and half of this goes dark. Memory stores remember. Mount Helicon judges what's still true. The verifier — with a memory."

---

## CONTINUOUS SPOKEN SCRIPT (~300 words, ~145 wpm)

> I have two years of agent memory — fifteen projects, four tools, almost four thousand live notes. I can't tell you which of it is still true, and neither can my agents. So I built the exam. **Twelve ways memory rots, checked live, across the whole board.** Right now, seven of twelve are firing. That's not a mock. That's my real memory, **failing its own test.**
>
> Here's what a memory store can't do. Two of my notes disagree on what Yieldbound even *is* — a yield treasury in one, a wallet tracker in another. A store kept both and will cite either one tomorrow. **Helicon sees the fork.** So I rule it. Once. Yieldbound is a treasury — the other reading loses. And it clears.
>
> The ruling doesn't just get filed. **It compiles into the Golden Rules my agent reads before it writes** — with the receipt. And the instant anything contradicts it, it re-alarms. A store forgets it ever asked. Helicon remembers what I ruled. Catch it, rule it, **never again.**
>
> Here's the part most demos hide. Pointed at my own store, my own exam comes back **DEGRADED.** Grounding under half, one task broken. A system that reports its own weakness is the product; one that shows you a green light is just another benchmark.
>
> And every judgment here runs on Qwen — **Model Studio** for the calls, **DashScope** for the embeddings. Kill the key and half of this goes dark. Memory stores remember. Mount Helicon judges what's still true. **The verifier — with a memory.**

---

## HOW TO CAPTURE

**Browser:** full-screen, dark theme, 125–150% zoom so text is legible on playback. Pre-load each tab once (warms the chunk + data) before the clean take.

**Beats verified 2026-07-19** on the real board:
- *The Exam* prints the 12-class scorecard live (`7/12` on this run — read yours).
- *Needs Ruling* carries real rulable forks — `#355 yieldbound treasury/tracker`, plus `machine`, `litmus`, `qwen`, and the RELAY→FAVOUR supersession (215 live cubes still asserting the dead name). Ruling `yieldbound` clears it from the exam — the ruling sticks.
- *Memory* / health reads DEGRADED from `data/eval-latest.json` (grounding ~0.39 live; 2 healthy / 10 degraded / 1 broken — read yours before the take).
- *Qwen as Judge* shows the Qwen judging surface — the visual Alibaba proof.

**Honest scope note — the re-alarm.** The never-twice re-alarm fires reliably in the one-command `scripts/demo_mem0_audit.py --mock` flow; on the full 8k-cube board it needs an embedding rescan and does not reproduce from a single insert. So this script *speaks* the never-twice guarantee over the Golden Rules screen rather than staging an on-screen re-alarm. If you want it shown, cut ~8s to the `--mock` demo's Phase 4 (it prints the re-alarm) and back.

**No hosted URL is shown or claimed.** The Alibaba proof is the running Qwen/DashScope calls behind every judgment + the linked code files (`qwen.py`, `embeddings.py`) + the deployable `fc/` config.

**Edit rhythm:** hard cuts between tabs; hold ~1.5s on the fork clearing in Beat 2 and on the DEGRADED verdict in Beat 4; close on the tagline card.
