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

## How the loop answers the judging criteria

- **Technical + engineering innovation (30%)** - a closed evaluate-attribute-rule-law loop over memory, with a deterministic 12-class exam and Qwen-judged contradiction, all read-only.
- **Creative AI implementation + architecture (30%)** - the thesis: evaluate memory by its output, not in isolation. Nobody ships a productized knowledge-memory verifier with human rulings that compile into obeyed law.
- **Real-world relevance + market (25%)** - runs on a real store of ~6,900 memories (~3,800 live) across ~15 live projects, scanned from Claude Code, git, Obsidian and agent skill files. It grows on every scan, so `helicon doctor` prints the count of the day rather than this sentence claiming a fixed one. The field (Mem0's own 2026 report, GLOVE) now agrees memory maintenance is the bottleneck.
- **Presentation + docs (15%)** - this architecture, a 3-min demo, and the one-command moat demo.

## The edge, now closed (Output → Attribute → Rule → Law as one path)

The one edge that fully earns the thesis is **output-failure attributed back to the memory that caused it**. It is now wired: `review --terminals` catches a contradicted output; `helicon attribute <finding>` retrieves the pre-existing memories that assert the false claim; `helicon resolve <id> --truth "…" --retire <memory_id>` writes the reality-checked correction AND supersedes the causing memory, so retrieval stops serving the rot at its source. The correction compiles into GOLDEN_RULES the agent obeys next session. Verified live: a "Yieldbound is a wallet tracker" contradiction traced back to the exact memories asserting it.

Honest scope: attribution v1 is deterministic FTS retrieval (the human picks which surfaced candidate to retire); semantic + Qwen-confirmed ranking is the next refinement. The loop exists end-to-end; the ranking gets sharper.
