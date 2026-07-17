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

Verbatim terminal output, run live against the real store at commit `7b3256d`:

```
$ helicon guard "4 hackathon wins"

  BLOCKED — 1 ruling(s) contradict this output:

    [critical] wins for 'hackathon' was ruled '9', but this asserts '4' — ruled wrong (re-alarms if it returns).
        ↳ ruling #281 on 'hackathon' wins at 2026-07-06T08:58:48


$ helicon guard "9 hackathon wins"

  ✓ clean — no ruling contradicts this output.


$ helicon guard "RELAY is live with real money"

  WARN — 1 ruling(s) contradict this output:

    [warning] 'RELAY' is a dead name (renamed to 'FAVOUR' 2026-07-02); use 'FAVOUR'.
        ↳ rebrand executed Jul 2 (decision log)
```

Three deterministic classes, each tracing to a real ruling with provenance: **ruled facts** (a value a human ruled wrong for a topic), **dead names** (renames), and ruled identity (a definition ruled against). Note the severity split: a ruled-wrong fact **blocks**, a dead name **warns**. The guard reads `audit_log`, the adjudication record, not the memory store, so a ruling cannot be eroded by decay or outvoted by newer memory.

The guard is exposed as the `helicon_guard` MCP tool, so any Qwen/Claude agent can consult the law **before** it writes a claim, not get audited after. This is the honesty thesis made true: adjudication that actually binds.

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

**Code files demonstrating use of Alibaba Cloud services and APIs** (the rule asks for a link to a code file, so here are the three that matter):

| File | Alibaba Cloud service | What it does |
|---|---|---|
| [`helicon/qwen.py`](https://github.com/MorkeethHQ/mount-helicon/blob/extra-mile/helicon-2026-07-16/helicon/qwen.py#L28-L36) | **Model Studio / MaaS** (`dashscope-intl.aliyuncs.com`, `token-plan.ap-southeast-1.maas.aliyuncs.com`) | Builds the Qwen client and drives every LLM call (`qwen3.6-flash` / `qwen3.6-plus` / `qwen3.7-max`) via the OpenAI-compatible SDK, with tier routing and a token-cost log |
| [`helicon/embeddings.py`](https://github.com/MorkeethHQ/mount-helicon/blob/extra-mile/helicon-2026-07-16/helicon/embeddings.py#L81-L118) | **DashScope** (`text-embedding-v4`, 1024-dim) | `_embed_provider()` / `embed_batch()`: the whole retrieval stack is Qwen-native. 4,214 memories embedded on DashScope, hybrid-searched against FTS5 |
| [`fc/s.yaml`](https://github.com/MorkeethHQ/mount-helicon/blob/extra-mile/helicon-2026-07-16/fc/s.yaml) + [`fc/Dockerfile`](https://github.com/MorkeethHQ/mount-helicon/blob/extra-mile/helicon-2026-07-16/fc/Dockerfile) | **Function Compute** (Serverless Devs) | Container deploy of the read-only FastAPI dashboard/API |

Verify the dependency in one line, no reading required:

```bash
$ python3 -c "import json; c=json.load(open('config.json')); print(c['qwen_base_url']); print(c['embeddings']['base_url'], c['embeddings']['model'])"
https://token-plan.ap-southeast-1.maas.aliyuncs.com/compatible-mode/v1
https://dashscope-intl.aliyuncs.com/compatible-mode/v1 text-embedding-v4
```

## What `helicon report` says about itself right now: DEGRADED (live)

Run it with `--llm`, which is the **full** exam (all six context tests, not just the four deterministic ones). It prints **DEGRADED**, and that is the most honest thirty seconds of the submission:

```
$ helicon report --llm

Overall: DEGRADED   (battery: 2 healthy / 9 degraded / 2 broken of 13 tasks; last scan 6.0h ago)

1. Efficient storage & retrieval          HEALTHY
   P@3 0.692  MRR 0.603  (n=13, small internal benchmark, one label per query)
   ingest dedup rate 0.997, 17 consolidations
2. Timely forgetting                      HEALTHY
   decay predicts human kills: rank-AUC 0.781; freshness pass rate 0.846
3. Recall under limited context windows   HEALTHY
   thinness pass 1.0, redundancy pass 0.923, ~994 tokens/query (top-5)
4. Cross-session accuracy                 DEGRADED
   snapshots: 1 regressed of 13; contradiction pass 0.846, grounding pass 0.462
   cross-source pairing: 8 live conflict(s), 3 open finding(s)
```

**Read the battery split honestly: 2 healthy, not 7.** Plain `helicon report` prints `7 healthy / 4 degraded / 2 broken`, because without `--llm` the Contradiction and Grounding tests never run and 7 tasks are counted healthy on a partial exam. Worse, it printed `(LLM tests off: no key)` on a machine with a working key, blaming the environment for a missing flag. Both were fixed while preparing this submission: the headline now says `deterministic-only` when it is, and the message names the flag instead of guessing at the cause. The flattering number was one command away from being the number in this document, which is precisely the failure mode the tool exists to catch.

**What holds the verdict at DEGRADED**, all of it real and none of it papered over: **grounding pass 0.462** (the Qwen judge finds fewer than half the retrieved contexts specific and verifiable), **8 live cross-source conflicts / 3 open findings** in the claim selector, and **1 retrieval regression of 13**. A system that reports its own degradation is the product; one that hides it behind a green light is just another benchmark.

### The 2 broken tasks, diagnosed rather than hidden

Two of the 13 benchmark tasks (`Bagel agent deployment and operations`, `Content Strategy`) fail the **critical Freshness** test. Both fail for the same reason, and the diagnosis is worth more than a green number would be:

```
[BROKEN] Content Strategy
   FAIL Freshness (critical)  1 retrieved memories killed/decayed: ['Edited: dashboard.md']
   FAIL Expiry               2 decayed below 0.15: ['Edited: dashboard.md (conf 0.00, 49d)',
                                                    'Content Strategy - May 2026 (conf 0.04, 19d)']
```

`Edited: dashboard.md` is not a memory. It is a **raw diff hunk** scraped from a Claude Code transcript (`File: <path>` plus a truncated `-`/`+` fragment). It decayed to confidence 0.0014 and **still ranks into the top 5**. Three findings sit underneath that, all verified live:

1. **Forgetting does not reach retrieval.** `hybrid_search` fuses semantic rank and FTS rank via Reciprocal Rank Fusion. Confidence is carried into the result and **never scored**. Helicon computes a decay signal it validates at rank-AUC 0.781, then ignores it when choosing what to serve. Dead memory outranks live memory because nothing tells retrieval it is dead.
2. **Approved memory is immortal.** `apply_decay` runs on `review_status IN ('pending','revised')`. It never touches `approved`, so the servable set and the decaying set are not the same set. Reviewing a cube already sets `last_reinforced = now` and bumps `review_count`, which extends the half-life (`eta * (1 + 0.5 * review_count)`). The model already honors a human's blessing by extending stability, so exempting `approved` from decay grants a second, unintended immortality on top of it. The pathology it produces: `Content Strategy - May 2026` was approved *while already decayed to 0.0*, so it is pinned at dead-zero forever and can never be reinforced back. The human's approval was silently discarded.
3. **The corpus is mostly exhaust.** 5,408 of 7,529 cubes (**72%**) are `Edited:`/`Created:` file-edit records; 2,933 are still servable. The single retrieval regression is the same story: task `Search` dropped `Created: search.py` and gained `Edited: data.py`, which is exhaust displacing exhaust.

**Why this is not fixed in this submission, stated plainly:** every route to 0 broken is a core change (decay scope, retrieval ranking, or ingest policy) with system-wide blast radius, and the honest thing three days from a deadline is to name it, not to ship it untested. One route was prototyped and rejected on evidence: widening `apply_decay` to include `approved` would decay the **rulings** (`Resolved: Hackathon wins = 9` from 1.0 to 0.64), which are settled facts that time should not erode. The guard survives that (it reads `audit_log`, not `helicon_cubes`), but the retrieval surface for settled facts would not. The correct fix is type-aware: rulings are overturned by a newer ruling, never by forgetting. That is the next commit, not this one.

This is the thesis pointed at its own author. The exam returns **red on the store of the person who wrote it**, and the red is specific enough to fix.

The retrieval-regression number has a history worth telling: on 2026-07-15 it read **12 of 13 regressed**, and it was wrong — `regressed` meant "anything changed at all", so it counted the loop *working* as a failure (16 of 17 missing baseline memories were missing because Helicon had correctly killed them as rot, and a better memory took each vacated slot). A regression is now only what it should always have been: a memory still live and no longer retrieved. 12 → 1. The same day the exam also could not reproduce its own verdict (11/12/11 across three runs) because retrieval called a non-deterministic remote reranker; fixed with stable tie-breaks and a memoized rerank (reproducible answer, honestly not a deterministic model).

An earlier draft of this section claimed that number had reached **0 of 13** and that "the 0 is real." It is not, and the correction belongs in the document rather than in a git history nobody reads. It currently reads **1**, and `data/watch.log` shows it flipping across the last three scheduled scans:

```
R8 Retrieval regression: ROT FOUND -> CLEAN
R8 Retrieval regression: CLEAN -> ROT FOUND
R8 Retrieval regression: ROT FOUND -> CLEAN
```

The single regression is task `Search` dropping `Created: search.py` and gaining `Edited: data.py`. All three are file-edit exhaust, so what the metric is measuring at the 0↔1 boundary is exhaust displacing exhaust, which is churn rather than signal. A one-of-thirteen metric that flaps between two adjacent values is not a number to quote proudly; it is a threshold sitting exactly where the corpus is noisiest. Named here rather than discovered by a judge.

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
- **Real-world relevance + market (25%)** — runs on a real store of **7,529 memories (3,925 live, 3,604 retired)** across ~15 live projects, scanned from Claude Code, git, Obsidian and agent skill files; the store grows on every scan, so `helicon doctor` prints today's count rather than this one. The field (Mem0's own 2026 report; Memora's "64% of errors = failure to forget") now agrees memory maintenance is the bottleneck — and the surviving gap is real in-the-wild data with a human-labeled key, which is exactly what this is.
- **Presentation + docs (15%)** — this architecture, a sub-3-min demo, and two one-command hero demos (`demo_mem0_audit.py --mock`, `helicon guard`).

---

> **DRAFT (voice pass pending — Oscar to flavor):** the demo narration, the exact spoken hero lines, and any first-person "my system failing my own threshold" phrasing are placeholders. Numbers above are live as of the last `helicon report`; re-run before recording.
