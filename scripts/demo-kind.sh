```bash
#!/usr/bin/env bash
set -euo pipefail

kind create cluster --name pvcsec --wait 90s || true

kubectl create ns loki --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns falco --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns observability --dry-run=client -o yaml | kubectl apply -f -

helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm upgrade --install loki grafana/loki -n loki
helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --set grafana.enabled=false

helm upgrade --install falco falcosecurity/falco -n falco -f helm-values/values-falco.yaml
helm upgrade --install sidekick falcosecurity/falcosidekick -n falco -f helm-values/values-falcosidekick.yaml
helm upgrade --install talon falcosecurity/falco-talon -n falco -f helm-values/values-talon.yaml

kubectl -n loki apply -f manifests/loki-ruler-falco-io.yaml
kubectl -n observability apply -f manifests/am-to-talon-bridge.yaml

echo "OK. Verifique: kubectl -n falco logs deploy/talon || kubectl -n loki get prometheusrules"