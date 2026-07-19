# Mount Helicon — Golden Submission

**What it is (truthfully):** the trust and governance layer for agent memory.
The one loop it makes feel complete today:

> an agent's claim or memory → the evidence and why it's uncertain → a human ruling
> in plain language → a durable rule → protection against the mistake coming back.

Mount Helicon is not a finished "Context OS" — that's the north star. This
submission makes **one closed governance loop** real, safe, and legible from a
cold clone.

---

## First run (exact commands, no credentials, no personal data)

```bash
git clone https://github.com/MorkeethHQ/mount-helicon.git
cd mount-helicon
pip install -e .
helicon demo          # seeds a labelled demo store + opens the dashboard
```

Then open **http://127.0.0.1:8420**. That's it — one command, a populated
dashboard, bound to localhost, keyless. No `helicon init`, no scan of your
machine, no API key. (`bash scripts/judge-check.sh` reproduces this from a fresh
clone and asserts it.)

---

## The three-minute judge story (all in the dashboard, no terminal after launch)

The demo store is 11 **labelled, planted** memories — a vegetarian-then-chicken
contradiction, a marathon whose date has passed, a bank balance stored as durable
memory, and one entity ("Aurora") defined two incompatible ways across sources.
Real detectors fire on them; only the data is seeded.

1. **Needs Ruling (0:00–0:45).** The queue opens on what needs a human. The hero:
   *"Identity fork: 'Aurora' is a payments protocol in one source and a lending
   market in another."* Open it — the two source memories are the evidence, and
   Helicon shows *why* it's flagged (two grounded sources, incompatible genus).
2. **Rule fast — verdicts stage (0:45–1:30).** Type the canonical truth —
   *"a payments protocol"* — and stage it. Rule the next finding (the phantom
   association) too. Nothing is written yet; a tray shows *"2 staged."* No shell
   command, no per-item commit.
3. **One Apply → a receipt (1:30–2:20).** Hit **Apply 2**. Each ruling reports
   its effect and *what is now protected*, with a real verify badge —
   *"● recorded · ● in GOLDEN_RULES."* The rulings are compiled into the law the
   agent reads before it writes. One **Undo all** reverses the whole batch. This
   is the felt loop: rule a few things, apply once, see it propagate.
4. **The whole board (2:20–3:00).** Open **The Exam**: the deterministic rot
   classes firing live on the planted drifts — a settled preference gone stale, a
   goal whose date passed, a fast fact stored as durable memory. The system reports
   its own state honestly, including what's degraded.

**Observed vs inference vs decision vs roadmap:** the source memories and the
exam verdicts are *observed*; the identity/phantom flags are *inference* (labelled
deterministic, no ground truth); the ruling is the *human decision*; anything about
model routing, skills/routines governance, or cross-session outcome learning is
*roadmap* (see below), never presented as working.

---

## What is real now

- **One-command, safe, seeded first run** (`helicon demo`) — populated dashboard,
  localhost-bound, keyless, zero personal data.
- **The govern-by-exception loop, batched**: findings with their source evidence
  → plain-language rulings that **stage** (no shell commands, no per-item write) →
  **one Apply** → a **receipt** proving each ruling landed (recorded + compiled
  into `GOLDEN_RULES`, checked against real post-apply state) → **one Undo all**.
  The compiled rulings become law the guard enforces before an agent writes, and
  re-alarm if contradicted (never-twice). Backed by `/api/govern/apply-batch` +
  `/api/govern/undo-batch`, with tests pinning coherent apply, isolated
  partial-failure, total undo, and bounded blast radius.
- **Multi-source, read-only ingest** (Claude Code, git, Obsidian, skills, Mem0
  format) — Helicon reads memory, never becomes a store.
- **The 12-class rot exam** (deterministic + optional Qwen-judged), from CLI,
  MCP, or dashboard.
- **Honest self-report**: the exam grades its own store and returns DEGRADED,
  naming its weak spots rather than showing a green light.
- **Qwen / Alibaba native**: inference on Model Studio, embeddings on DashScope
  (the demo runs keyless; live judging uses the key).

## What is intentionally roadmap (labelled, not faked)

- **The second loop — task → scoped context → verified artifact → outcome.** The
  `TaskRun`/`ContextPacket` recorder (`taskrun-contextpacket-design.md`) is
  design-only. Until it exists, Helicon makes **no** causal claim about which
  context, skill, or model to use next.
- **Prescriptive model routing.** Withheld below a quality floor — `helicon route`
  emits *"no model clears the quality floor"* rather than a route on coin-flip
  evidence. Turning it on is gated on min-sample + min-verified-rate + task-class
  comparability.
- **Governing skills and routines** from the same cockpit, and **write-back** of
  corrected law into skills/rules files.

## Security and privacy defaults

- The server binds **127.0.0.1** by default. The API mutates the store without
  auth, so it must not face the network; `--host` opts in with a printed warning.
- The demo scans **no personal source** — connectors are empty; the review queue
  and skills audit only scan directories you explicitly wire via config.
- The demo is **keyless** and fully **local**; nothing leaves the machine.
- The demo store is labelled `demo` throughout and can never be confused with a
  live audit.

## Known limitations (stated plainly)

- **Retrieval "utility" is correlation, not causal.** Marking a memory useful can
  retro-mark past retrievals; it cannot prove a memory helped a specific task.
  This is why the second loop (TaskRun/ContextPacket) is the next build, and why
  no causal-learning claim is made in the UI or here.
- **Output verification is claim-level**, extracted from closeout/commit text —
  it does not yet check a task's declared acceptance criterion. That's the
  TaskRun contract, roadmap.
- **The demo is seeded fixtures**, deterministic by design; the live experience on
  a real store (thousands of memories) is richer but requires `helicon init` and
  a key for the Qwen-judged classes.
- **Model-routing evidence is thin and confounded**; the floor is why it stays
  off, not a claim that it works.
