#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
IMAGE_NAME="${INPUT_IMAGE_NAME:-}"
IMAGE_TAG="${INPUT_IMAGE_TAG:-latest}"
REGISTRY="${INPUT_REGISTRY:-ghcr.io}"

if [ -z "$IMAGE_NAME" ]; then
  printf '{"event":"pull","status":"skipped","reason":"no_image_name"}\n' >> "${LOG}"
  exit 0
fi

echo "[pull] Verifying container image availability..."
echo "[pull] Image: $IMAGE_NAME:$IMAGE_TAG"

# Only pull if we have access (allow failure)
if docker pull "$IMAGE_NAME:$IMAGE_TAG" 2>/dev/null; then
  printf '{"event":"pull","status":"success","image":"%s:%s"}\n' "$IMAGE_NAME" "$IMAGE_TAG" >> "${LOG}"
else
  printf '{"event":"pull","status":"info","message":"image pull may require authentication"}\n' >> "${LOG}"
fi

echo "[pull] Image verification complete"
