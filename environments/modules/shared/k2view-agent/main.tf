resource "helm_release" "k2view_agent" {
  name        = "${var.namespace}"
  namespace   = "default"
  repository  = "https://nexus.share.cloud.k2view.com/repository/k2view-agent/"
  chart       = "k2view-agent"

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
    value = "${var.cloud_provider}"
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
 
  set {
    name  = "secrets.NETWORK_NAME"
    value = "${var.network_name}"
  }

  set {
    name  = "secrets.SUBNETS"
    value = "${var.subnets}"
  }
  
  set {
    name  = "secrets.SUBNET_NAME"
    value = "${var.subnet_name}"
  }
  
  # Azure
  set {
    name  = "secrets.AZURE_SUBSCRIPTION_ID"
    value = "${var.azure_subscription_id}"
  }

  set {
    name  = "secrets.AZURE_RESOURCE_GROUP_NAME"
    value = "${var.azure_resource_group_name}"
  }

  set {
    name  = "secrets.AZURE_OIDC_ISSUER_URL"
    value = "${var.azure_oidc_issuer_url}"
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
    name  = "serviceAccount.azure_workload_identity_client_id"
    value = "${var.azure_workload_identity_client_id}"
  }

  set {
    name  = "secrets.AZURE_SPACE_IDENTITY_CLIENT_ID"
    value = "${var.azure_space_identity_client_id}"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}
