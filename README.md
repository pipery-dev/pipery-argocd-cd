# Pipery ArgoCD CD

CD pipeline for ArgoCD: update image tag → sync application → wait for Argo rollout

## Status

- Owner: `pipery-dev`
- Repository: `pipery-argocd-cd`
- Marketplace category: `continuous-integration`
- Current version: `3.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-argocd-cd@v3
        with:
          project_path: .
          config_file: .github/pipery/config.yaml
          argocd_server: 
          argocd_app: 
          argocd_token: 
          image_name: 
          image_tag: ${{ github.sha }}
          sync_timeout: 300
          prune: false
          force: false
          skip_update: false
          skip_sync: false
          skip_status_check: false
          log_file: pipery.jsonl
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.github/pipery/config.yaml` | Path to the pipery config file. |
| `argocd_server` | no | `` | ArgoCD server URL (e.g. argocd.example.com). |
| `argocd_app` | no | `` | ArgoCD application name. |
| `argocd_token` | no | `` | ArgoCD authentication token. |
| `image_name` | no | `` | Container image name to update in ArgoCD. |
| `image_tag` | no | `${{ github.sha }}` | Container image tag to deploy. |
| `sync_timeout` | no | `300` | Seconds to wait for ArgoCD sync. |
| `prune` | no | `false` | Prune resources during sync. |
| `force` | no | `false` | Force sync even if app is in sync. |
| `skip_update` | no | `false` | Skip image tag update step. |
| `skip_sync` | no | `false` | Skip ArgoCD sync step. |
| `skip_status_check` | no | `false` | Skip rollout status check. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
