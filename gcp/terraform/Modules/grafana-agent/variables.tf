variable "namespace" {
  type    = string
  default = "grafana-agent"
}

variable "cluster_name" {
  type    = string
}

variable "externalservices_prometheus_host" {
  type    = string
  default = "https://prometheus-prod-01-eu-west-0.grafana.net"
}

variable "externalservices_prometheus_basicauth_username" {
  type    = number
  default = 980823
}

variable "externalservices_prometheus_basicauth_password" {
  type    = string
  default = ""
}

variable "externalservices_loki_host" {
  type    = string
  default = "https://logs-prod-eu-west-0.grafana.net"
}

variable "externalservices_loki_basicauth_username" {
  type    = number
  default = 593028
}

variable "externalservices_loki_basicauth_password" {
  type    = string
  default = ""
}

variable "externalservices_tempo_host" {
  type    = string
  default = "https://tempo-eu-west-0.grafana.net:443"
}

variable "externalservices_tempo_basicauth_username" {
  type    = number
  default = 589541
}

variable "externalservices_tempo_basicauth_password" {
  type    = string
  default = ""
}

variable "metrics_enabled" {
  type    = bool
  default = true
}

variable "metrics_cost_enabled" {
  type    = bool
  default = true
}

variable "metrics_node_exporter_enabled" {
  type    = bool
  default = true
}

variable "logs_enabled" {
  type    = bool
  default = true
}

variable "logs_pod_logs_enabled" {
  type    = bool
  default = true
}

variable "logs_cluster_events_enabled" {
  type    = bool
  default = true
}

variable "traces_enabled" {
  type    = bool
  default = false
}

variable "receivers_grpc_enabled" {
  type    = bool
  default = true
}

variable "receivers_http_enabled" {
  type    = bool
  default = true
}

variable "receivers_zipkin_enabled" {
  type    = bool
  default = true
}

variable "receivers_grafanacloudmetrics_enabled" {
  type    = bool
  default = false
}

variable "opencost_enabled" {
  type    = bool
  default = true
}

variable "kube_state_metrics_enabled" {
  type    = bool
  default = true
}

variable "prometheus_node_exporter_enabled" {
  type    = bool
  default = true
}

variable "prometheus_operator_crds_enabled" {
  type    = bool
  default = true
}
