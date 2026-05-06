# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-argocd-cd/main/assets/icon.png" alt="Pipery ArgoCD CD" width="28" align="center" /> Pipery ArgoCD CD

Reusable GitHub Action for ArgoCD deployment with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20ArgoCD%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-argocd-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-argocd-cd@v1
        with:
          argocd_server: argocd.example.com
          argocd_app: my-app
          image_tag: ${{ github.sha }}
          argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Update | Update image tag in manifests | `skip_update` |
| Sync | ArgoCD sync application | `skip_sync` |
| Status check | Wait for application rollout | `skip_status_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `argocd_server` | `` | ArgoCD server URL (e.g., `argocd.example.com`). |
| `argocd_app` | `` | ArgoCD application name. |
| `argocd_token` | `` | ArgoCD authentication token. |
| `image_name` | `` | Container image name to update in ArgoCD. |
| `image_tag` | `${{ github.sha }}` | Container image tag to deploy. |
| `sync_timeout` | `300` | Seconds to wait for ArgoCD sync. |
| `prune` | `false` | Prune resources during sync. |
| `force` | `false` | Force sync even if app is in sync. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |
| `skip_update` | `false` | Skip image tag update step. |
| `skip_sync` | `false` | Skip ArgoCD sync step. |
| `skip_status_check` | `false` | Skip rollout status check. |

## Usage Examples

### Example 1: Basic ArgoCD deployment

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-argocd-cd@v1
        with:
          argocd_server: ${{ vars.ARGOCD_SERVER }}
          argocd_app: my-app
          image_tag: ${{ github.sha }}
          argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 2: With image name update

```yaml
- uses: pipery-dev/pipery-argocd-cd@v1
  with:
    argocd_server: argocd.example.com
    argocd_app: my-app
    image_name: my-app
    image_tag: ${{ github.sha }}
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 3: Force sync with resource pruning

```yaml
- uses: pipery-dev/pipery-argocd-cd@v1
  with:
    argocd_server: argocd.example.com
    argocd_app: my-app
    image_tag: ${{ github.sha }}
    force: true
    prune: true
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 4: Extended sync timeout

```yaml
- uses: pipery-dev/pipery-argocd-cd@v1
  with:
    argocd_server: argocd.example.com
    argocd_app: my-app
    image_tag: ${{ github.sha }}
    sync_timeout: "600"
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 5: Skip status checks for faster deployment

```yaml
- uses: pipery-dev/pipery-argocd-cd@v1
  with:
    argocd_server: argocd.example.com
    argocd_app: my-app
    image_tag: ${{ github.sha }}
    skip_status_check: true
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 6: Production deployment with release tag

```yaml
- uses: pipery-dev/pipery-argocd-cd@v1
  with:
    argocd_server: argocd.example.com
    argocd_app: my-app-prod
    image_name: my-app
    image_tag: v${{ github.ref_name }}
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-argocd-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `ARGOCD_TOKEN` - ArgoCD authentication token
- `ARGOCD_SERVER` - ArgoCD server URL (e.g., argocd.example.com)
- `ARGOCD_APP` - ArgoCD application name

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `ARGOCD_TOKEN` - ArgoCD authentication token
   - `ARGOCD_SERVER` - ArgoCD server URL
   - `ARGOCD_APP` - ArgoCD application name
3. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → update → sync → status_check → logs

### Features

- Manifest image tag updates
- ArgoCD application sync
- Automatic rollout monitoring
- Resource pruning support
- Custom sync timeouts
- Health checks
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
