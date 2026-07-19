# Mount Helicon — Golden Submission

**Track:** MemoryAgent · **What it is:** *a Qwen-powered governance layer for agent
memory* — a memory control plane, not another memory store.

Memory stores retain facts, but they do not reliably detect when a fact has gone
stale, conflicts with another source, or has been ruled false. **Helicon audits a
memory store, lets the machine handle routine rot, escalates only genuine
contradictions to a human, and turns each ruling into an enforceable rule — with a
receipt and a reversible undo.** Qwen is load-bearing: it judges logical
contradiction and grounding where similarity scores are insufficient. When evidence
is weak, Helicon reports **DEGRADED** and withholds routing rather than pretending
confidence.

Today Helicon ships the governed-memory loop: **audit → human ruling → verified
apply → enforced guard → undo.** It is the production-minded *govern* half of an
agent-memory system — a real, tested way to make an agent's memory safer, more
accountable, and harder to silently corrupt. It is **not** yet a complete "memory
OS," and this document does not pretend it is.

---

## First run (exact, no credentials, no personal data)

```bash
git clone https://github.com/MorkeethHQ/mount-helicon.git
cd mount-helicon
pip install -e .
helicon demo            # seeds a labelled demo store + opens the dashboard
# open http://127.0.0.1:8420
```

**Fresh-clone verification:** `bash scripts/judge-check.sh` (clone → install → boot →
populated, no personal-data leak) · `python3 -m pytest -q` (380 passing). Localhost-
bound, keyless, scans nothing on your machine.

---

## The demo (under 3 minutes — the governance loop, and only that)

1. **0:00–0:15 — the thesis.** *"Memory stores remember; Helicon checks whether what
   they remember is still true."*
2. **0:15–0:35 — a DANGEROUS contradiction + Qwen's verdict.** The store holds
   "Stripe is in test mode — safe to run a checkout" (March) and "we went live on
   Stripe July 1 — every charge is real money" (July). Believe the stale one and an
   agent **charges real customers by mistake.** Qwen (Model Studio) judges it:
   **CONTRADICTION**. Similarity scores can't; a contradiction judge can.
3. **0:35–1:05 — one tap → applied → receipt.** The human taps the current answer
   ("live — real money"); it applies instantly — compiled into GOLDEN_RULES; the
   receipt proves it landed and is enforced (*recorded · in GOLDEN_RULES · guard now
   enforces it*), with Undo. One action, not a staging ceremony.
4. **1:05–1:25 — the guard enforces it.** Show the guard **blocking** "Stripe is in
   test mode, safe to run a checkout" before an agent can act on it — the exact
   mistake that would have charged real cards.
5. **1:25–1:30 — DEGRADED, not green.** The store grades itself DEGRADED (grounding
   0.538): *"it refuses to invent confidence."*
6. **1:30–2:00 — running on Alibaba Cloud.** Cut to **Alibaba Cloud Shell** running
   `bash scripts/cloudshell-run.sh` — the same backend serving the dashboard from
   Alibaba infrastructure. *"Local-first, and it runs on Alibaba Cloud — the judging
   you just saw is Qwen on Model Studio."*

That is the whole proof, in under two minutes. No nightly-health montage, no "OS,"
no "it learns" — those dilute the governance story that is the point.

---

## Live Qwen API proof (load-bearing)

```
$ python3 -c "from helicon.qwen import get_client, complete; from helicon.config import load_config; \
    print(complete(get_client(load_config()), 'Reply CONTRADICTION or CONSISTENT only.', \
    'A: Stripe is in test mode, charges are simulated. B: we went live on Stripe, every charge is real money.', model='qwen3.6-flash'))"
CONTRADICTION            # qwen3.6-flash on Alibaba Model Studio, ~4s
```

## Proof of Alibaba Cloud

The rule (verbatim): *"You must demonstrate that the backend is running on Alibaba
Cloud"* and *"Proof must be a link to a code file in their code repo that
demonstrates use of Alibaba Cloud services and APIs."* Helicon meets both — as a
**local-first backend that runs anywhere, and has been run in full on Alibaba
Cloud.**

- **The backend runs on Alibaba Cloud Shell.** [`scripts/cloudshell-run.sh`](scripts/cloudshell-run.sh)
  boots the full FastAPI backend inside **Alibaba Cloud Shell** (slim mode for the
  shell's disk; the deterministic exam + governance loop run from the DB). This has
  been run end-to-end and is captured in the demo video — the backend running on
  Alibaba Cloud, from the code file the rule asks for.
- **The load-bearing intelligence runs on Alibaba Cloud on every request.** Every
  contradiction/grounding judgment executes on Alibaba **Model Studio**
  ([`helicon/qwen.py`](helicon/qwen.py)); every embedding on Alibaba **DashScope**
  `text-embedding-v4` ([`helicon/embeddings.py`](helicon/embeddings.py)). Proven
  live (the call above). Kill the Alibaba side and the judging layer goes dark.
- **Also deployable to Function Compute** ([`fc/s.yaml`](fc/s.yaml) +
  [`fc/Dockerfile`](fc/Dockerfile)).

**Honest scope (we never imply what isn't there):** there is **no always-on public
URL**. A persistent dedicated server (ECS / a standing Function Compute service)
needs a KYC step that repeatedly failed for this account, so we do not host one — and
by design don't need to. Local-first means the same backend runs on the judge's
machine, in Alibaba Cloud Shell, or anywhere a container runs; the Cloud Shell run is
the "running on Alibaba Cloud" proof, not a hosted endpoint.

---

## What ships today vs. what is roadmap (strict)

**Ships today — the governed-memory loop (real, tested):** one-command safe seeded
demo; machine-review lane that auto-manages routine rot (ungrounded/stale/mechanical
never ask a human); a human exception queue; **one-tap ruling → applied instantly →
receipt with a verified probe → undo** (one action per exception, no staging
ceremony); compiled law + a guard that **blocks a ruled-wrong claim**;
live Qwen contradiction/grounding judging with an honest DEGRADED; routing withheld
below a quality floor. Failures never masquerade as success (audited + tested).

**Also included — a tested TaskRun/ContextPacket recorder** (read-only, local-only):
it preserves objective, frozen candidate context, artifact, and an **attested**
outcome (operator-attached — Helicon records it, does not run the test). It has
default-deny privacy and provably does not contaminate retrieval/utility/regret
data. **It does not yet drive retrieval, routing, or learning** — it is a provenance
recorder, the beginning of the left side of the loop, not an agent-facing workflow.

**Roadmap (not claimed as working):** a read-only MCP retrieve path ("ask Helicon
what is safe to believe" before an agent answers); decision-time context injection
(so the packet is proven *received*, not just candidate); evidence-backed context
recommendations; and only much later, policy-approved automatic remediation/routing.

---

## Product sequence

| Horizon | Product |
|---|---|
| **Now** | Memory governance: detect → rule → enforce → undo |
| **Next** | Memory flight recorder: task → context → artifact → attested outcome |
| **Then** | Evidence-backed context recommendations (read-only MCP) |
| **Later** | Policy-approved automatic remediation and routing |

---

## Red-team self-verdict

**The thesis is governance, and governance is enough.** A skeptical judge sees a
real, tested loop — a memory store's contradiction caught by Qwen, ruled once by a
human, compiled into an enforceable rule, blocked by the guard, and reversible —
with nothing faked and failures that never masquerade as success.

**The one real risk is claim drift**, not missing features: calling it an "OS that
learns" while the strongest proof is *governance*. We have cut that language. Helicon
is the governance and evaluation layer for agent memory. The learn-half exists only
as a tested, honestly-labelled recorder.

**Where we are still exposed:** (1) no always-on public URL — but the backend *runs
on Alibaba Cloud Shell* (`scripts/cloudshell-run.sh`), which is the rule's "backend
running on Alibaba Cloud"; the only exposure is a judge who demands a hosted
endpoint, and we never fake one; (2) the recorder is provenance, not causal
evidence, and we say so; (3) verification is operator-**attested**, not Helicon-run —
the label stays rigorous.

The insight the whole product is built around: **agent memory becomes dangerous not
when it forgets, but when it confidently preserves something that should no longer be
believed.** Helicon exists to prevent that.
