# Mount Helicon — 3-Minute Demo (shot-list + spoken script)

**North star:** the verifier with a memory.
**Punchline (everything builds to it):** *A store forgets it ever asked. Helicon remembers what you ruled.*
**Rule:** one on-screen moment per beat. Nothing said that isn't shown. Zero fake data: the opening exam and the closing guard run on the author's real store (~3,900 live memories); the loop in the middle runs on a bundled Mem0-format store, and the voiceover says so.

> **Every command below is verified working (2026-07-19).** The four beats are four single commands — no manual note-injection, no live URL, nothing fragile to fumble on camera. Numbers move on every scan; read yours off the frozen copy (see HOW TO CAPTURE) and say those.

**Total: 4 beats, ~3:00. VO ≈ 420 words (~145 wpm, leaves room for the pauses).**

---

## THE SPINE — four commands, verified

```
helicon audit                                   # the exam: 12 classes, 7 rotting, live on the real board
python3 scripts/demo_mem0_audit.py --mock       # the whole loop, one command: fork → rule → re-audit → re-alarm
helicon guard "we have 4 hackathon wins"        # the ruling BLOCKS a wrong claim before it's written
# close: one live Qwen judgment landing on Model Studio / DashScope
```

---

## SHOT LIST

| # | t | ON SCREEN (one moment) | SPOKEN (VO) | On-screen text |
|---|-----|------------------------|-------------|----------------|
| 1 | 0:00–0:30 | `helicon audit` runs; the 12-class scorecard fills in; cursor rests on `7/12 classes show rot right now · 12/12 fully tested`; R4 shows `RELAY->FAVOUR … 24 IN CODE` | "I have two years of agent memory. Fifteen projects, four tools, almost four thousand live notes — and I can't tell you which of it is still true. Neither can my agents. So I built the exam. One command, across the whole board. Twelve ways memory rots, checked live. Right now, seven of twelve are firing. That isn't a mock store. That's my real memory — failing its own test." | `whole board · 12 classes · live` |
| 2 | 0:30–1:35 | `python3 scripts/demo_mem0_audit.py --mock` → Phase 1 R11 `aurora (protocol/market)` + R12 `aurora->solana`; Phase 2 the two rulings + the compiled Golden Rules; Phase 3 `CLEAN`; **beat of silence**; Phase 4 `R11 ROT FOUND` re-alarm | "Here's the one thing a memory store cannot do. Point Helicon at a store — this one is Mem0's own format. Two memories disagree on what Aurora even *is*: a payments protocol in one, a lending market in another. Plus a claim nothing ever grounded — Aurora rides Solana. A store kept all three and will cite any of them tomorrow. Helicon sees the fork. So I rule it. Once. Aurora is a payments protocol — the other reading loses. And the ruling doesn't just get filed. It compiles into the rules my agent reads before it writes. Re-audit: clean. Then a new memory sneaks the old definition back in. A store would just save it. Watch — re-alarm. The instant a settled verdict is contradicted, it fires again." | `rule once → it becomes law` · (Phase 4) `never twice` |
| 3 | 1:35–2:15 | `helicon guard "we have 4 hackathon wins"` → `BLOCKED — 1 ruling(s) contradict this output` + `ruled '9' … asserts '4'` + `ruling #281` | "And that memory has teeth. I once ruled my hackathon-win count at nine. So watch what happens when an agent tries to write four. Blocked — before it's ever said. The ruling became policy, and policy stops the mistake from coming back, with the receipt attached: ruling two-eighty-one. That is the loop closed. Catch it, rule it, and never again." | `caught before it's written` |
| 4 | 2:15–3:00 | Split or cut: the `report`/eval line `DEGRADED · grounding 0.538 · 1 broken`, then a terminal firing one live Qwen call, the token-cost log ticking up against `dashscope-intl.aliyuncs.com` | "Here's the part most demos hide. I point the exam at my own store, and it comes back DEGRADED. Grounding at point five three eight. One task broken, nine strained. A system that reports its own weakness is the product; one that shows you a green light is just another benchmark. And every judgment you just watched runs on Qwen — Model Studio for the calls, DashScope for the embeddings, live, right now. Kill the key and half of this goes dark. Memory stores remember. Mount Helicon judges what's still true. The verifier — with a memory." | `Mount Helicon` |

---

## CONTINUOUS SPOKEN SCRIPT (~420 words, read at ~145 wpm)

> I have two years of agent memory. Fifteen projects, four tools, almost four thousand live notes — and I can't tell you which of it is still true. Neither can my agents. So I built the exam. **One command, across the whole board. Twelve ways memory rots, checked live.** Right now, seven of twelve are firing. That isn't a mock store. That's my real memory — **failing its own test.**
>
> Here's the one thing a memory store cannot do. Point Helicon at a store — this one is Mem0's own format. Two memories disagree on what Aurora even *is*: a payments protocol in one, a lending market in another. Plus a claim nothing ever grounded — Aurora rides Solana. A store kept all three and will cite any of them tomorrow. **Helicon sees the fork.**
>
> So I rule it. Once. Aurora is a payments protocol — the other reading loses. And the ruling doesn't just get filed. **It compiles into the rules my agent reads before it writes.** Re-audit: clean.
>
> Then a new memory sneaks the old definition back in. A store would just save it. Watch — **re-alarm.** The instant a settled verdict is contradicted, it fires again.
>
> And that memory has teeth. I once ruled my hackathon-win count at nine. So watch what happens when an agent tries to write four. **Blocked — before it's ever said.** The ruling became policy, and policy stops the mistake from coming back, with the receipt attached: ruling two-eighty-one. That is the loop closed. **Catch it, rule it, and never again.**
>
> Here's the part most demos hide. I point the exam at my own store, and it comes back **DEGRADED.** Grounding at point five three eight. One task broken, nine strained. A system that reports its own weakness is the product; one that shows you a green light is just another benchmark.
>
> And every judgment you just watched runs on Qwen — **Model Studio** for the calls, **DashScope** for the embeddings, live, right now. Kill the key and half of this goes dark.
>
> Memory stores remember. Mount Helicon judges what's still true. **The verifier — with a memory.**

---

## HOW TO CAPTURE (one sitting, repeatable)

**Terminal:** dark theme, ≥18pt, narrow window (no wrap), clean prompt. Pre-run each command once to warm the embedding model + Qwen cache, then screen-record a clean replay. Type nothing on camera — paste or use `↑`.

**Demo on a COPY so takes are repeatable** (the guard reads rulings; the mem0 demo writes to a bundled store, not yours):
```bash
cp data/helicon.db /tmp/demo.db
export HELICON_DB=/tmp/demo.db          # or point config.json db_path at the copy
```

**Beat 1 — `helicon audit`** (real board, read-only). Verified 2026-07-19: `7/12 classes show rot right now · 12/12 fully tested, 0 partial`, R4 shows `RELAY->FAVOUR … 24 IN CODE`. The exam prints no memory total; if the overlay needs one, `helicon doctor` prints `… memories (… live, … retired)`. **Re-read the 7/12 off your own run** — it moves.

**Beat 2 — `python3 scripts/demo_mem0_audit.py --mock`** (bundled Mem0-format store, no key, deterministic). Verified: prints the four phases end to end — R11 `aurora (protocol/market)`, R12 `aurora->solana`; the two rulings + compiled Golden Rules; Phase 3 `CLEAN`; Phase 4 re-alarm. This is the one-command loop; nothing to stage. Hold ~1.5s on the Phase-4 re-alarm before cutting.

**Beat 3 — `helicon guard "we have 4 hackathon wins"`** (real rulings). Verified: `BLOCKED — 1 ruling(s) contradict this output` / `wins for 'hackathon' was ruled '9', but this asserts '4'` / `ruling #281`. Robust; needs your real store (or the copy).

**Beat 4 — the honest close.** The DEGRADED numbers are live in `data/eval-latest.json` (`overall: DEGRADED`, `grounding_pass_rate 0.538`, `battery: 3 healthy / 9 degraded / 1 broken`); show them via `helicon report --llm` or an overlay. Then fire ONE live Qwen call and let the token-cost log tick — e.g. `helicon battery "some task"` (judges on Qwen) or the dashboard's usage panel. **No hosted URL is shown or claimed** — the Alibaba proof is the running Qwen/DashScope calls + the linked `qwen.py` / `embeddings.py` code files + the deployable `fc/` config.

**Edit rhythm:** hard cuts between commands. Music drops for the silence before the Phase-4 re-alarm and before `BLOCKED`. Open on the exam, close on the tagline card.

---

## Honest scope note

No single project trips all 12 classes, so the arc is *whole-board breadth* (Beat 1, real) + *the moat loop* (Beat 2, on a Mem0 store) + *policy with teeth* (Beat 3, real ruling) + *self-reported degradation* (Beat 4, real). Claiming one project hits every class would be fake — and Helicon would catch it.
