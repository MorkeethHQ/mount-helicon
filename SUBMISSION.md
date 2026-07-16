# Mount Helicon — Qwen Cloud Global AI Hackathon (Track: MemoryAgent)

**Deadline:** Jul 20, 2026, 2:00 PM PDT (verified at the Devpost source Jul 16; the "Jul 8" on early posts was the original date, extended). **Prize:** $7K cash + $3K Alibaba Cloud credits per track. **Video:** under 3 minutes.

Mount Helicon is the **exam a memory store never runs on itself**: it audits a live memory for rot, lets a human rule a contradiction once, compiles that ruling into law the agent obeys before it writes, and **re-alarms the instant the ruled-wrong value returns**. Memory stores keep the write path. Helicon is the verification layer on top of it.

---

## Hero 1 — audit Alibaba's own recommended Qwen memory backend (one command, zero setup)

Alibaba's Model Studio docs recommend **Mem0** (with AnalyticDB) as the memory backend for Qwen agents. Mem0 stores and retrieves; its docs never mention contradiction, decay, or a fork in what an entity *is*. Helicon reads a Mem0 store **read-only** (via the shipped `mem0` connector) and runs the rot exam on it:

```bash
python3 scripts/demo_mem0_audit.py --mock     # bundled Mem0-format store, no key/account
MEM0_API_KEY=m0-... python3 scripts/demo_mem0_audit.py   # your real Mem0 store
```

Four phases, end to end:

1. **Audit** — the Mem0 store holds `Aurora is a payments protocol` and `Aurora is a lending market`. Mem0 kept both; it cannot *see* the identity fork. Helicon's R11 gate does.
2. **Rule** — you rule Aurora canonical (`a payments protocol`). The verdict is stored with provenance.
3. **Compile to law** — the ruling becomes a line in `GOLDEN_RULES.md`, the file the agent reads before it writes.
4. **Never-twice** — a *new* memory arrives re-asserting `Aurora is a lending market after all`. Mem0 would just store it, recency winning. Helicon **re-alarms** — the ruling you made fires again the instant it's contradicted.

That fourth phase is the whole thesis in one screen: **a memory store can represent SUPERSEDED (recency wins); it cannot represent FALSE-and-stays-false.** Helicon can.

## Hero 2 — the ruling BINDS at write time (guard)

A ruling that only lives in a file is advisory. Helicon enforces it. A human already ruled `hackathon wins = 9` (finding #281); the value `4` was ruled wrong and set to re-alarm. So:

```
$ helicon guard "4 hackathon wins"
  BLOCKED — 1 ruling(s) contradict this output:
    [critical] wins for 'hackathon' was ruled '9', but this asserts '4' — ruled wrong (re-alarms if it returns).
        ↳ ruling #281 on 'hackathon' wins at 2026-07-06T08:58:48

$ helicon guard "9 hackathon wins"
  ✓ clean — no ruling contradicts this output.
```

The guard is exposed as the `helicon_guard` MCP tool, so any Qwen/Claude agent can consult the law **before** it writes a claim, not get audited after. It checks three deterministic classes, each tracing to a real ruling: dead names (renames), ruled identity (a definition ruled against), and **ruled facts** (a value a human ruled wrong for a topic). This is the honesty thesis made true: adjudication that actually binds.

---

## The thesis (one line)

**Memory has no intrinsic quality. It is only as good as the context it surfaces and the output it drives.** The only honest way to evaluate a memory is downstream: does the context it retrieves still pass, and does the output it produces hold up against reality? Staleness and contradiction are early proxies for "this will cause a bad output." A memory whose output is never evaluated is an untested assumption.

Mount Helicon closes that loop: it evaluates memory by its output, attributes a bad output back to the memory that caused it, lets a human rule once, and compiles that ruling into law the agent obeys next time.

## The loop (the architecture)

```
 STORE ─▶ RETRIEVE ─▶ OUTPUT ─▶ ATTRIBUTE ─▶ RULE ─▶ LAW ─┐
 (is it   (is the     (does it   (which       (human   (agent   │
  true?)   context     hold vs    memory       settles  obeys    │
           right?)     reality?)  caused it?)  it)      it)      │
   ▲                                                             │
   └──────────────────  better STORE  ◀─────────────────────────┘
```

| Stage | Question | Helicon command | Status |
|---|---|---|---|
| **Store** | Is memory internally true? | `helicon audit` (12-class rot exam) | solid |
| **Retrieve** | Is the retrieved context right? | `helicon battery` / `helicon snapshot` | solid |
| **Output** | Does the agent's claim hold vs reality? | `helicon review --terminals [--run]` | shipped |
| **Attribute** | Which memory caused the bad output? | `helicon attribute <finding>` | shipped (v1 ranking is deterministic FTS) |
| **Rule** | Human settles it, once | `helicon resolve <id>` | solid |
| **Law** | The agent obeys it next session | `helicon policy --inject` → `GOLDEN_RULES.md`, enforced at write time by `helicon guard` | wired |

Same evaluators point at the other producers of agent behavior: **skills** (`connectors/skills.py`), **routines/crons** (`stackwatch.py`), and the **regret** signal (`regret.py`) — killed memory the output later needed back.

## Qwen + Alibaba Cloud (backend dependency, not decoration)

~22 modules call Qwen: contradiction and identity judging, consolidation synthesis, portrait narration, next-move generation, volatility scoring. Embeddings run on Alibaba **DashScope** (`text-embedding-v4`); inference on Alibaba **Model Studio / MaaS** (`token-plan.ap-southeast-1.maas.aliyuncs.com`). Kill the key and half the intelligence layer goes dark. The read-only dashboard/API deploys on Alibaba **Function Compute** for the deployment proof (ECS dropped on KYC).

## What `helicon report` says about itself right now: DEGRADED (live)

Run it. It prints **DEGRADED**, and that is the most honest thirty seconds of the submission:

```
Overall: DEGRADED   (battery: 6 healthy / 5 degraded / 2 broken of 13 tasks)
4. Cross-session accuracy                 DEGRADED
   snapshots: 0 regressed of 13
   cross-source pairing: 8 live conflict(s), 3 open finding(s)
```

The threshold for retrieval regression is **zero**, and retrieval regression is now clean (0 of 13). What holds the verdict at DEGRADED is the **8 live cross-source conflicts / 3 open findings** in the claim selector — real disagreements the system refuses to paper over. A system that reports its own degradation is the product; one that hides it behind a green light is just another benchmark.

The retrieval-regression number has a history worth telling: on 2026-07-15 it read **12 of 13 regressed**, and it was wrong — `regressed` meant "anything changed at all", so it counted the loop *working* as a failure (16 of 17 missing baseline memories were missing because Helicon had correctly killed them as rot, and a better memory took each vacated slot). A regression is now only what it should always have been: a memory still live and no longer retrieved. 12 → 1 → 0, and the 0 is real. The same day the exam also could not reproduce its own verdict (11/12/11 across three runs) because retrieval called a non-deterministic remote reranker; fixed with stable tie-breaks and a memoized rerank (reproducible answer, honestly not a deterministic model).

The remaining 8 conflicts are the claim selector, and some are the same both-poles shape `GOLDEN_RULES` already carries dismissals for. Named here rather than discovered by a judge.

## Differentiation — why this is not another memory agent

The field the judges will see most of: **Mem0, Zep/Graphiti, Cognee.** They are memory *stores* with automatic contradiction handling. That automatic resolution is exactly the gap.

- **Mem0** stores/retrieves; add/update/delete is an LLM decision at write. Contradiction = the LLM chooses to replace. No human authority, no binding, no re-alarm.
- **Zep / Graphiti** ship a bi-temporal knowledge graph; a contradicted edge gets a `t_invalid` and recency wins. That represents **SUPERSEDED**, never **FALSE** — the same wrong value can win again the next time it's asserted more recently.
- **Cognee** reweights by popularity; **Anthropic's memory tool** is LRU; **OpenAI** ships "treat memories as guidance only." None can say *"a human decided this, and it stays decided."*

Helicon's wedge is three things none of them have:

1. **Human ruling is the authority, not an LLM guess.** Ground truth = the operator's verdict, stored with provenance. The way individuals have historically broken open this space is "construct independent ground truth, then catch a model lying" — here the operator *is* the oracle, and the ruling is the held-out key.
2. **The ruling BINDS.** It compiles into `GOLDEN_RULES` the agent reads before it writes, and `helicon guard` blocks a ruled-wrong value at write time (Hero 2). Enforced, not advisory.
3. **Never-twice / re-alarm.** A ruled-wrong value re-alarms the instant it returns in newer memory — at audit time *and* write time. Recency cannot overturn a ruling. Mem0/Zep would silently accept the re-assertion (Hero 1, phase 4).

And the framing that disarms "yet another store": Helicon runs **on** Mem0 (read-only), Alibaba's own recommended Qwen memory backend. It is not a competitor to the store the judges' stack recommends — it is the exam that store never runs on itself.

One result that proves LLM-judged contradiction is not enough: in the model bake-off, **every model — Qwen, Claude, GPT — missed unit-drift** (points counted as dollars). A class of rot only a deterministic exam catches, never an LLM judge grading its own context.

## How the loop answers the judging criteria

- **Technical + engineering innovation (30%)** — a closed evaluate→attribute→rule→law loop over memory, a deterministic 12-class exam, Qwen-judged contradiction, and a write-time guard that binds rulings. All read-only on the source store.
- **Creative AI implementation + architecture (30%)** — the thesis: evaluate memory by its output, not in isolation, with human rulings that compile into obeyed, write-time-enforced law. Nobody ships that.
- **Real-world relevance + market (25%)** — runs on a real store of ~6,900 memories (~3,800 live) across ~15 live projects, scanned from Claude Code, git, Obsidian and agent skill files; `helicon doctor` prints the live count. The field (Mem0's own 2026 report; Memora's "64% of errors = failure to forget") now agrees memory maintenance is the bottleneck — and the surviving gap is real in-the-wild data with a human-labeled key, which is exactly what this is.
- **Presentation + docs (15%)** — this architecture, a sub-3-min demo, and two one-command hero demos (`demo_mem0_audit.py --mock`, `helicon guard`).

---

> **DRAFT (voice pass pending — Oscar to flavor):** the demo narration, the exact spoken hero lines, and any first-person "my system failing my own threshold" phrasing are placeholders. Numbers above are live as of the last `helicon report`; re-run before recording.
