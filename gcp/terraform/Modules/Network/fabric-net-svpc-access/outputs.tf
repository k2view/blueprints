output "service_projects" {
  description = "Project ids of the services with access to all subnets."
  value = [
    for i, k in google_compute_shared_vpc_service_project.projects : k.service_project
  ]
}
