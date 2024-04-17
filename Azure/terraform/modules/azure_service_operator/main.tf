resource "azurerm_user_assigned_identity" "aso_identity" {
  location            = var.location
  name                = "aso-identity"
  resource_group_name = var.node_resource_group
}

resource "azurerm_role_assignment" "aso_role_assignment" {
  depends_on          = [ azurerm_user_assigned_identity.aso_identity ]
  scope                = "/subscriptions/${var.subscription}/resourceGroups/${var.node_resource_group}"
  principal_id         = azurerm_user_assigned_identity.aso_identity.principal_id
  role_definition_name = "Contributor"
}

resource "azurerm_role_assignment" "aso_role_assignment_rbacadmin" {
  depends_on          = [ azurerm_user_assigned_identity.aso_identity ]
  scope                = "/subscriptions/${var.subscription}/resourceGroups/${var.node_resource_group}"
  principal_id         = azurerm_user_assigned_identity.aso_identity.principal_id
  role_definition_name = "Role Based Access Control Administrator"
}

resource "azurerm_federated_identity_credential" "aso_federated_credentaial" {
  depends_on          = [ azurerm_role_assignment.aso_role_assignment ]
  name                = "aso-federated-credential"
  resource_group_name = var.node_resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aso_identity.id
  subject             = "system:serviceaccount:${var.aso_namespace}:azureserviceoperator-default"
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  wait_for_jobs    = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "aso" {
  depends_on = [
    helm_release.cert-manager,
    azurerm_federated_identity_credential.aso_federated_credentaial
  ]
  name             = "aso"
  repository       = "https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts"
  chart            = "azure-service-operator"
  namespace        = var.aso_namespace
  create_namespace = true

  set {
    name  = "azureSubscriptionID"
    value = var.subscription
  }
  set {
    name  = "azureTenantID"
    value = azurerm_user_assigned_identity.aso_identity.tenant_id
  }
  set {
    name  = "azureClientID"
    value = azurerm_user_assigned_identity.aso_identity.client_id
  }
  set {
    name  = "useWorkloadIdentityAuth"
    value = "true"
  }
  set {
    name  = "crdPattern"
    value = "resources.azure.com/*;managedidentity.azure.com/*;authorization.azure.com/*;storage.azure.com/*;dbforpostgresql.azure.com/*"
  }
}

resource "helm_release" "azure_resources" {
  depends_on       = [ helm_release.aso ]
  name             = "azure-resources"
  chart            = "../modules/azure_service_operator/helm"
  wait_for_jobs    = true

  values = [
    "${file("../modules/azure_service_operator/helm/values.yaml")}"
  ]

  set {
    name = "namespace"
    value = var.aso_namespace
  }
  set {
    name = "resource_group_name"
    value = var.node_resource_group
  }
  set {
    name = "location"
    value = var.location
  }
  set {
    name = "oidc_endpoint"
    value = var.oidc_issuer_url
  }
  set {
    name = "aks_public_ip"
    value = var.aks_public_ip
  }
  set {
    name = "k2agent.config"
    value = var.k2agent_config
  }

}
