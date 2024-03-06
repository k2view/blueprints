helm upgrade --install grafana-k8s-monitoring . \
  --namespace "grafana-agent" --create-namespace --values - <<EOF
cluster:
  name: me-west-1-gcp
externalServices:
  prometheus:
    host: {grafana-api}
    basicAuth:
      username: "{grafana-user}"
      password: "{grafana-password}"
  loki:
    host: {grafana-logs-api}
    basicAuth:
      username: "{grafana-user}"
      password: "{grafana-password}"
opencost:
  opencost:
    exporter:
      defaultClusterId: me-west-1-gcp
    prometheus:
      external:
        url: {grafana-api}/api/prom
EOF
