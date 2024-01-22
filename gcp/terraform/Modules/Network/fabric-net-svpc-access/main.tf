resource "google_compute_shared_vpc_service_project" "projects" {
  provider        = google-beta
  for_each        = { for i, k in toset(var.service_project_ids) : k => i }
  host_project    = var.host_project_id
  service_project = each.key
}

resource "google_compute_subnetwork_iam_binding" "network_users" {
  for_each = { for i, k in var.host_subnets : k => i }

  project    = var.host_project_id
  region     = element(var.host_subnet_regions, each.value)
  subnetwork = each.key
  role       = "roles/compute.networkUser"
  members    = compact(split(",", lookup(var.host_subnet_users, each.key)))
}

resource "google_project_iam_binding" "service_agents" {
  count   = var.host_service_agent_role ? 1 : 0
  project = var.host_project_id
  role    = "roles/container.hostServiceAgentUser"
  members = var.host_service_agent_users
}
