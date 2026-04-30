#!/usr/bin/env bash
set -euo pipefail

# Pipery ArgoCD CD - Main orchestrator
# Orchestrates: update image tag → sync application → wait for Argo rollout

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
LOG="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "[pipery-argocd-cd] ERROR: project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$LOG")"

# Step: read config
"$SCRIPT_DIR/read-config.sh"

# Step: update image tag
if [ "${INPUT_SKIP_UPDATE:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-update.sh"
else
  echo "[pipery-argocd-cd] Skipping image tag update step."
fi

# Step: sync application
if [ "${INPUT_SKIP_SYNC:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-sync.sh"
else
  echo "[pipery-argocd-cd] Skipping sync step."
fi

# Step: status check
if [ "${INPUT_SKIP_STATUS_CHECK:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-status.sh"
else
  echo "[pipery-argocd-cd] Skipping status check step."
fi

# Final success log entry (always written)
printf '{"event":"deploy","status":"success","target":"argocd","mode":"cd"}\n' >> "${INPUT_LOG_FILE:-pipery.jsonl}"

echo "[pipery-argocd-cd] CD pipeline completed for: ${PROJECT_PATH}"
