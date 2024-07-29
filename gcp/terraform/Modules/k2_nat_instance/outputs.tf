output "nat_reserved_ip" {
  # value       = google_compute_address.nat_reserved_private_ip.address
  value       = google_compute_instance.nat_gateway.network_interface[0].network_ip
  description = "NAT instance reserved IP"
}