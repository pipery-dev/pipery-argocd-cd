#!/usr/bin/env bash
set -euo pipefail

# ArgoCD setup - install ArgoCD CLI
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

echo "[setup] Setting up ArgoCD CLI environment..."

if ! command -v argocd >/dev/null 2>&1; then
  echo "[setup] Installing ArgoCD CLI..."
  ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
  ARGOCD_VERSION=${ARGOCD_VERSION:-latest}

  if [ "$ARGOCD_VERSION" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${ARCH}"
  else
    DOWNLOAD_URL="https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCH}"
  fi

  curl -sSL "$DOWNLOAD_URL" -o /usr/local/bin/argocd
  chmod +x /usr/local/bin/argocd
fi

argocd version --client || true
printf '{"event":"setup","status":"success","message":"ArgoCD CLI ready"}\n' >> "${LOG}"
echo "[setup] ArgoCD setup complete"
