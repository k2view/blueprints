variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "k2view_agent_namespace" {
  description = "The name of K2view agent namespace"
  type        = string
}

variable "space_roles" {
  description = "List of roles to assign to the space service account"
  type        = list(string)
  default     = ["roles/storage.objectUser", "roles/cloudsql.client", "roles/iam.workloadIdentityUser", "roles/secretmanager.secretAccessor"]
}

variable "deployer_permissions" {
  description = "List of permissions for the deployer role"
  type        = list(string)
  default     = [
    # Permissions from roles/storage.admin
    "storage.buckets.create",
    "storage.buckets.delete",
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    
    # Permissions from roles/iam.serviceAccountAdmin
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.update",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.setIamPolicy",

    # Permissions from roles/alloydb.admin
    "alloydb.clusters.create",
    "alloydb.clusters.delete",
    "alloydb.clusters.get",
    "alloydb.clusters.list",
    "alloydb.instances.create",
    "alloydb.instances.delete",
    "alloydb.instances.get",
    "alloydb.instances.list",
    "alloydb.operations.get",
    "alloydb.operations.list",

    # Permissions from roles/cloudsql.admin
    "cloudsql.backupRuns.create",
    "cloudsql.backupRuns.delete",
    "cloudsql.backupRuns.get",
    "cloudsql.backupRuns.list",
    "cloudsql.databases.create",
    "cloudsql.databases.delete",
    "cloudsql.databases.get",
    "cloudsql.databases.list",
    "cloudsql.databases.update",
    "cloudsql.instances.create",
    "cloudsql.instances.delete",
    "cloudsql.instances.get",
    "cloudsql.instances.list",
    "cloudsql.instances.update",
    "cloudsql.sslCerts.create",
    "cloudsql.sslCerts.delete",
    "cloudsql.sslCerts.get",
    "cloudsql.sslCerts.list",
    "cloudsql.users.create",
    "cloudsql.users.delete",
    "cloudsql.users.list",
    "cloudsql.users.update"
  ]
}