#!/usr/bin/env bash
# One-command deploy of Mount Helicon's read-only dashboard to Alibaba Cloud
# Function Compute. Builds the lean custom-container image at repo root, pushes
# it to Alibaba Container Registry (ACR), then registers the FC web function via
# Serverless Devs. Idempotent — re-run to ship a new build.
#
# Prereqs (see DEPLOY-FC.md for the ~15-min first-time setup):
#   - docker, aliyun CLI, and `s` (Serverless Devs v3) installed
#   - `s config add` profile created (default: "default")
#   - ACR namespace created and `docker login` done to the ACR registry
#   - QWEN_API_KEY and DASHSCOPE_API_KEY exported in this shell
#   - web/dist built (cd web && npx vite build) and data/helicon.db present
set -euo pipefail

# ---- config (override via env) ----
REGION="${HELICON_FC_REGION:-ap-southeast-1}"
NAMESPACE="${HELICON_ACR_NAMESPACE:-helicon}"
ACCESS="${HELICON_S_ACCESS:-default}"
IMAGE="registry.${REGION}.aliyuncs.com/${NAMESPACE}/helicon-fc:latest"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Preflight"
[ -f web/dist/index.html ] || { echo "web/dist missing — run: (cd web && npx vite build)"; exit 1; }
[ -f data/helicon.db ]     || { echo "data/helicon.db missing"; exit 1; }
: "${QWEN_API_KEY:?export QWEN_API_KEY before deploy (Model Studio inference key)}"
: "${DASHSCOPE_API_KEY:?export DASHSCOPE_API_KEY before deploy (embeddings key)}"
command -v s >/dev/null || { echo "Serverless Devs 's' not installed — npm i -g @serverless-devs/s"; exit 1; }

echo "==> Building image: $IMAGE  (context: repo root, lean/keyless)"
DOCKER_BUILDKIT=1 docker build --platform linux/amd64 -f fc/Dockerfile -t "$IMAGE" .

echo "==> Pushing to ACR (run 'docker login registry.${REGION}.aliyuncs.com' first if this fails)"
docker push "$IMAGE"

echo "==> Deploying FC web function via Serverless Devs"
s deploy -t fc/s.yaml --access "$ACCESS" \
  --var "region=${REGION}" --var "namespace=${NAMESPACE}" --var "access=${ACCESS}"

echo
echo "==> Done. The public HTTP trigger URL is printed above (…fcapp.run / …functioncompute…)."
echo "    Verify:  curl <url>/api/health   ->  {\"status\":\"ok\",\"cubes\":<n>}"
echo "    Dashboard: open <url>/ in a browser."
