# Kubernetes PVC Security (K3s)

[![Validate](https://github.com/joaobarbosa7/pvc-security-k3s/actions/workflows/validate.yaml/badge.svg)](../../actions/workflows/validate.yaml)
[![Markdown](https://github.com/joaobarbosa7/pvc-security-k3s/actions/workflows/markdown.yaml/badge.svg)](../../actions/workflows/markdown.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Falco · Loki · Prometheus · Talon

Detect, correlate, and respond to suspicious PVC I/O in Kubernetes.  
Runtime signals via Falco→Loki.  
Metrics alerts via Prometheus→Alertmanager.  
Actions via a small bridge → Falco Talon.

## Why

Cut MTTD/MTTR for PVC-related anomalies.  
Keep a clear audit trail end-to-end.

## Architecture

- **Runtime:** Falco + FalcoSidekick → Loki
- **Metrics/Alerts:** Prometheus + Alertmanager
- **Action:** `am-to-talon-bridge`
  translates Alertmanager JSON to Talon HTTP API
- **Audit:** API server audit logs to Loki (optional)

![Architecture](docs/architecture.png)

## Repository layout

- **docs/**: report.pdf, diagram
- **manifests/**: Kubernetes YAML (bridge, rules)
- **helm-values/**: minimal Falco/Sidekick/Talon values
- **scripts/**: kind bootstrap and teardown
- **.github/workflows/**: CI — kubeconform, yamllint, markdownlint

## Key manifests

- **manifests/am-to-talon-bridge.yaml**: Alertmanager → Talon bridge
- **manifests/loki-ruler-falco-io.yaml**: alert rule from Falco logs
- **helm-values/**: minimal Falco/Sidekick/Talon config

## Results

See `docs/report.pdf` and `docs/screenshots/`  
for evidence of alert → action flow.

## Limitations

No HA for the bridge, minimal RBAC/NetworkPolicies, demo settings only.

## License

This project is licensed under the MIT License —  
see the [LICENSE](LICENSE) file for details.
