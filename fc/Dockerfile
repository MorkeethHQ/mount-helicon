# Function Compute custom-container image for Mount Helicon's read-only
# dashboard + API. Build context is the REPO ROOT (see deploy-fc.sh):
#   docker build -f fc/Dockerfile -t <image> .
# Lean by design — no torch/sentence-transformers (see fc/requirements.txt).
FROM python:3.12-slim

WORKDIR /app

# Deps first for layer caching.
COPY fc/requirements.txt ./fc/requirements.txt
RUN pip install --no-cache-dir -r fc/requirements.txt

# App code.
COPY helicon/ ./helicon/
COPY fc/config.fc.json ./fc/config.fc.json
COPY fc/entrypoint.sh ./fc/entrypoint.sh
RUN chmod +x ./fc/entrypoint.sh

# Prebuilt dashboard bundle (served by FastAPI from static/). Built locally with
# `cd web && npx vite build` — the image never runs Node.
COPY web/dist/ ./static/

# Seeded, REAL memory store (34MB, read-only baseline). entrypoint copies it to
# /tmp on boot so SQLite can open it writable. Zero fake data — this is Oscar's
# actual 5.7k-cube store.
COPY data/helicon.db ./data/helicon.db

# FC web function: container listens on this port, FC's http trigger forwards to
# it. Matches customContainerConfig.port in s.yaml.
ENV PORT=9000
EXPOSE 9000

ENTRYPOINT ["/app/fc/entrypoint.sh"]
