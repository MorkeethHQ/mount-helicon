# Mount Helicon - Qwen Cloud Global AI Hackathon (Track: MemoryAgent)

**Deadline:** Jul 20, 2026, 2pm PDT (verified at devpost source Jul 13; the old "Jul 9" in older docs was stale).

## The thesis (one line)

**Memory has no intrinsic quality. It is only as good as the context it surfaces and the output it drives.** So the only honest way to evaluate a memory is downstream: does the context it retrieves still pass, and does the output it produces hold up against reality? Staleness and contradiction are just early proxies for "this will cause a bad output." A memory whose output is never evaluated is an untested assumption.

Mount Helicon is the system that closes that loop: it evaluates memory by its output, attributes a bad output back to the memory that caused it, lets a human rule once, and compiles that ruling into law the agent obeys next time. A memory agent that learns from its own output.

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
| **Output** | Does the agent's claim hold vs reality? | `helicon review --terminals [--run]` | shipped Jul 13 |
| **Attribute** | Which memory caused the bad output? | `helicon attribute <finding>` | shipped Jul 13 (775e9b6); v1 ranking is deterministic FTS, see below |
| **Rule** | Human settles it, once | `helicon resolve <id>` | solid |
| **Law** | The agent obeys it next session | `helicon policy --inject` → `GOLDEN_RULES.md` | wired Jul 13 |

Plus the same evaluators pointed at the other producers of agent behavior: **skills** (`connectors/skills.py`), **routines/crons** (`stackwatch.py`), and the **regret ledger** (`regret.py`) - killed memory that the output later needed back, the output-driven signal that a forget was wrong.

## Qwen + Alibaba Cloud (backend dependency)

Qwen is load-bearing, not decorative. ~22 modules call it: contradiction and identity judging (the audit), consolidation synthesis, portrait narration, next-move generation, volatility scoring. Embeddings run on Alibaba **DashScope** (`text-embedding-v4`) and inference on Alibaba **Model Studio / MaaS** (`token-plan.ap-southeast-1.maas.aliyuncs.com`). Kill the key and half the intelligence layer goes dark. The backend already depends on Alibaba Cloud services; the read-only dashboard/API deploys on Alibaba **Function Compute** for the deployment proof (ECS was dropped on KYC).

## What `helicon report` says about itself right now: DEGRADED

Run it. It prints **DEGRADED**, and that is the submission's most honest thirty
seconds:

```
Overall: DEGRADED
4. Cross-session accuracy                 DEGRADED
   snapshots: 1 regressed of 13
   cross-source pairing: 8 live conflict(s), 3 open finding(s)
```

The threshold for retrieval regression is **zero**. One live memory that used to
be retrieved for the task "Search" no longer is, so the exam refuses to call
itself healthy. We are not hiding that behind a green light, because a system
that reports its own degradation is the product; one that hides it is just
another benchmark.

What that number is NOT: on 2026-07-15 this read **12 of 13 regressed**, and it
was wrong. `regressed` meant "anything changed at all", so it counted the loop
WORKING as a failure — 16 of 17 missing baseline memories were missing because
Helicon had killed them as rot, retrieval correctly stopped serving them, and a
better memory took each vacated slot. The exam was indicting the product for
succeeding. A regression is now only what it should always have been: a memory
that is still live and no longer retrieved. 12 -> 1, and the 1 is real.

The same day it also turned out the exam could not reproduce its own verdict —
three identical runs gave 11/13, 12/13, 11/13, because retrieval calls a remote
reranker that is not deterministic and silently fell back to a different ranking
whenever the call failed. Fixed (stable tie-breaks, memoized rerank), with the
honest caveat that caching makes the answer reproducible without making the
model deterministic.

The remaining 8 conflicts are the claim selector, and at least some are the same
both-poles shape GOLDEN_RULES already carries dismissals for. Named here rather
than discovered by a judge.

## How the loop answers the judging criteria

- **Technical + engineering innovation (30%)** - a closed evaluate-attribute-rule-law loop over memory, with a deterministic 12-class exam and Qwen-judged contradiction, all read-only.
- **Creative AI implementation + architecture (30%)** - the thesis: evaluate memory by its output, not in isolation. Nobody ships a productized knowledge-memory verifier with human rulings that compile into obeyed law.
- **Real-world relevance + market (25%)** - runs on a real store of ~6,900 memories (~3,800 live) across ~15 live projects, scanned from Claude Code, git, Obsidian and agent skill files. It grows on every scan, so `helicon doctor` prints the count of the day rather than this sentence claiming a fixed one. The field (Mem0's own 2026 report, GLOVE) now agrees memory maintenance is the bottleneck.
- **Presentation + docs (15%)** - this architecture, a 3-min demo, and the one-command moat demo.

## The edge, now closed (Output → Attribute → Rule → Law as one path)

The one edge that fully earns the thesis is **output-failure attributed back to the memory that caused it**. It is now wired: `review --terminals` catches a contradicted output; `helicon attribute <finding>` retrieves the pre-existing memories that assert the false claim; `helicon resolve <id> --truth "…" --retire <memory_id>` writes the reality-checked correction AND supersedes the causing memory, so retrieval stops serving the rot at its source. The correction compiles into GOLDEN_RULES the agent obeys next session. Verified live: a "Yieldbound is a wallet tracker" contradiction traced back to the exact memories asserting it.

Honest scope: attribution v1 is deterministic FTS retrieval (the human picks which surfaced candidate to retire); semantic + Qwen-confirmed ranking is the next refinement. The loop exists end-to-end; the ranking gets sharper.
