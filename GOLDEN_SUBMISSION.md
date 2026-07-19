# Mount Helicon — Golden Submission

**Track:** MemoryAgent · **Position:** *the Memory Operations System for AI agents.*

A local-first command center (dashboard + CLI + MCP) where **one operator governs
agent memory by exception** — the machine reviews most things automatically, the
human rules only the real exceptions, and every governed change lands with a
receipt and an undo. Qwen is load-bearing: it judges contradictions and grounding,
scores the store, and the store reports its own degradation honestly.

This document is strict about **real now vs. roadmap** and ends with a red-team
self-verdict on where the full-OS promise still outruns the build.

---

## First run (exact, no credentials, no personal data)

```bash
git clone https://github.com/MorkeethHQ/mount-helicon.git
cd mount-helicon
pip install -e .
helicon demo            # seeds a labelled demo store + opens the dashboard
# open http://127.0.0.1:8420
```

**Fresh-clone verification** (reproduces the judge's machine and asserts it works):
```bash
bash scripts/judge-check.sh     # clone → install → boot → populated, no personal-data leak
python3 -m pytest -q            # 374 passing
```

Localhost-bound, keyless, scans nothing on your machine.

---

## The operator-day story (≤5 minutes, all real today)

> *"Yesterday my agents worked across projects. Overnight Helicon reviewed the
> memory they left. This morning I open one cockpit, rule only the real
> exceptions, apply one governed update, and see it protect tomorrow's agents."*

1. **Machine review — the bulk, no human (0:00–0:45).** Open **The Exam**: the
   12-class rot scan runs live on the seeded store. Most findings are
   auto-managed — a stale marathon date, a balance stored as durable memory, an
   ungrounded phantom association — none of them ask for you. The header shows what
   Helicon handled without you.
2. **Human review — exceptions only (0:45–1:45).** Open **Needs Ruling**. The
   queue is short and legible: *"Two sources disagree — vegetarian in Nov, eats
   chicken again in Jun. Which is current?"* Only a human knows. Rule it in plain
   language; rule the identity fork too. Verdicts **stage** — nothing written yet.
3. **One governed Apply → receipt (1:45–2:45).** Hit **Apply 2**. Each ruling
   reports its effect and *what is now protected*, with a real verify badge —
   *"● recorded · ● in GOLDEN_RULES."* The guard will now block the ruled-wrong
   claim before an agent writes it. One **Undo all** reverses the batch. If the
   apply fails, it says so — it never implies success from a silent screen.
4. **Qwen, load-bearing (2:45–3:45).** The contradiction you just ruled was judged
   by **Qwen on Model Studio** — proven live below. The battery scores the store
   with Qwen and returns an honest **DEGRADED** (grounding 0.538), naming its weak
   spots instead of a green light.
5. **Nightly health (3:45–5:00).** Routine and skill liveness (`helicon doctor` /
   stackwatch) show last-run and explicit **degraded / never-ran** states — the
   loop that checks tomorrow whether the rule held.

---

## Live Qwen API proof (load-bearing, not decorative)

Real call to Alibaba **Model Studio**, judging the demo's hero contradiction:

```
$ python3 -c "from helicon.qwen import get_client, complete; from helicon.config import load_config; \
    print(complete(get_client(load_config()), 'Reply CONTRADICTION or CONSISTENT only.', \
    'A: user is vegetarian. B: user started eating chicken again.', model='qwen3.6-flash'))"
CONTRADICTION            # returned by qwen3.6-flash on Model Studio in ~4s
```

Code files demonstrating Alibaba Cloud use: [`helicon/qwen.py`](helicon/qwen.py)
(Model Studio inference), [`helicon/embeddings.py`](helicon/embeddings.py)
(DashScope `text-embedding-v4`). ~28 modules call Qwen; kill the key and the
judging/grounding/consolidation layer goes dark.

## Alibaba deployment proof (honest)

`fc/` is a complete Alibaba **Function Compute** container deploy
([`fc/s.yaml`](fc/s.yaml) + [`fc/Dockerfile`](fc/Dockerfile), one-command
`s deploy`). **There is no live hosted URL** — the account is KYC-blocked, stated
plainly. The Devpost rule asks for *"a code file demonstrating use of Alibaba Cloud
services and APIs,"* which the live Qwen/DashScope calls + `fc/` config satisfy.
The demo runs locally; nothing about the loop depends on a hosted URL.

---

## Real now vs. roadmap (strict)

**Real now:** one-command safe seeded demo; the govern-by-exception loop
(stage → one Apply → receipt with a verified probe → undo, backend + UI, tested at
the HTTP boundary); machine-review auto-managed lane; compiled law + guard; live
Qwen contradiction/grounding judging with honest DEGRADED; routing withheld below a
quality floor; multi-source read-only ingest; localhost-safe binding; no
personal-data leak.

**Roadmap (labelled, not shown as working):**
- **Task / work surface** — the `TaskRun`/`ContextPacket` recorder that binds
  objective ↔ frozen context ↔ artifact ↔ verification. Designed, not built. Until
  it exists, Helicon makes **no causal claim** about which context/skill/model to
  use next.
- **Reproducible A/B comparison surface** — routing evidence is thin and confounded
  today (hence the quality floor). A controlled feasibility comparison is the next
  build.
- **Nightly improvement as a first-class governed surface** (routines/skills as
  governed assets with suggested remedies) — the modules exist; the unified surface
  does not.
- **The meta-review** — the operator ruling on the *engine's own judgments/scores*
  so it learns its escalation criteria. Designed, not built.
- **Native Mac wrapper** — not packaged. This is a local-first browser + CLI
  command center; no fake app.

---

## Sequenced plan

**Must ship before submission (done):** one-command demo; govern loop + receipt +
undo; machine/human lane split; live Qwen proof; fresh-clone verification; honest
docs. **Post-submission roadmap:** TaskRun recorder → A/B comparison → nightly
governed surface → meta-review → routing turned on above the floor. **Cut from
claims:** "Context OS," autonomous optimization, agent-fleet-comparison-as-proof,
write-back, a native app, and any live-deployed URL.

---

## Red-team self-verdict

**What a skeptical judge will believe:** it installs and runs in one command to a
safe, populated cockpit; the govern-by-exception loop is real, tested end-to-end,
and honest (no shell commands, no faked propagation, receipts with a verify probe,
total undo); Qwen genuinely judges the contradiction on Model Studio; the system
reports its own DEGRADED state; failures never masquerade as success.

**Where it still fails the full-OS promise, stated plainly:**
1. **It is not yet a *learning* OS.** Without the TaskRun loop there is no causal
   evidence that tomorrow's agents are measurably better — the "improves over time"
   claim is roadmap, and we say so. This is the biggest gap.
2. **The evaluation surface is a read, not a comparison.** We show an honest
   DEGRADED and a floored router, not a reproducible A/B of two approaches. A judge
   wanting "compare two candidates" sees the honest floor instead.
3. **Nightly improvement is modules, not a surface.** The health signals exist; the
   first-class governed nightly view does not.
4. **The MCP retrieve path still mutates state on lookup** — a read-only mode is
   needed before an agent can safely "just look something up."
5. **No live Alibaba URL** — code-file + local proof only.

The honest one-liner: **Helicon today is a real, safe, Qwen-powered governance
cockpit for agent memory — the *govern* half of the OS, shipped and tested. The
*learn* half (task→context→outcome) is designed, not built, and we do not pretend
otherwise.**
