# Pipery ArgoCD CD

Reusable GitHub Action for ArgoCD CD with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20ArgoCD%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-argocd-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    uses: pipery-dev/pipery-argocd-cd@v1
    with:
      project_path: .
    secrets: inherit
```

## Pipeline steps

update image tag → ArgoCD sync → wait for rollout

Every step is logged to `pipery.jsonl` via psh and uploaded as a GitHub Actions artifact.

## Inputs

| Input | Description | Default |
|---|---|---|
| `project_path` | Path to the project source tree. | `.` |
| `config_file` | Path to the pipery config file. | `.github/pipery/config.yaml` |
| `argocd_server` | ArgoCD server URL (e.g. argocd.example.com). | `` |
| `argocd_app` | ArgoCD application name. | `` |
| `argocd_token` | ArgoCD authentication token. | `` |
| `image_name` | Container image name to update in ArgoCD. | `` |
| `image_tag` | Container image tag to deploy. | `${{ github.sha }}` |
| `sync_timeout` | Seconds to wait for ArgoCD sync. | `300` |
| `prune` | Prune resources during sync. | `false` |
| `force` | Force sync even if app is in sync. | `false` |
| `skip_update` | Skip image tag update step. | `false` |
| `skip_sync` | Skip ArgoCD sync step. | `false` |
| `skip_status_check` | Skip rollout status check. | `false` |
| `log_file` | Path to write the JSONL log file. | `pipery.jsonl` |

## Observability

Each run produces a `pipery.jsonl` file. Upload it as an artifact and inspect it with the [Pipery Dashboard](https://dash.pipery.dev).

## License

MIT — see [LICENSE](LICENSE).
