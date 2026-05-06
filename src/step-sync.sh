#!/usr/bin/env psh
# Pipery ArgoCD CD — sync step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Sync"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"
