resource "helm_release" "k2view_agent" {
  name       = "k2view-agent"

  repository = "https://raw.githubusercontent.com/k2view/blueprints/main/helm/k2view-agent"
  chart      = "k2view-agent"

  set {
    name  = "namespace.name"
    value = "${var.namespace}"
  }

  set {
    name  = "image.url"
    value = "${var.image}"
  }

  # secrets
  set {
    name  = "secrets.K2_MAILBOX_ID"
    value = "${var.mailbox_id}"
  }

  set {
    name  = "secrets.K2_MANAGER_URL"
    value = "${var.mailbox_url}"
  }

  set {
    name  = "secrets.CLOUD"
    value = upper(var.cloud_provider)
  }

  set {
    name  = "secrets.REGION"
    value = "${var.region}"
  }

  set {
    name  = "secrets.SPACE_SA_ARN"
    value = "${var.space_iam_arn}"
  }

  set {
    name  = "secrets.PROJECT"
    value = "${var.project}"
  }

  # serviceAccount
  set {
    name  = "serviceAccount.provider"
    value = lower(var.cloud_provider)
  }

  set {
    name  = "serviceAccount.arn"
    value = "${var.deployer_iam_arn}"
  }

  set {
    name  = "serviceAccount.gcp_service_account_name"
    value = "${var.gcp_service_account_name}"
  }

  set {
    name  = "serviceAccount.project_id"
    value = "${var.project_id}"
  }

  set {
    name  = "secrets.NETWORK_NAME"
    value = "${var.network_name}"
  }

  set {
    name  = "secrets.SUBNETS"
    value = "${var.subnets}"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}
