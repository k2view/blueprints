# NAT instance reserved IP - static IP for configuring in VPN
resource "google_compute_address" "nat_reserved_private_ip" {
  name         = "${var.cluster_name}-nat-reserved-ip"
  subnetwork   = var.subnet
  address_type = "INTERNAL"
  region       = var.region
}

# NAT instance route to route traffic from GKE to "dest_range" via the instance
resource "google_compute_route" "nat_instance_route" {
  name              = "${var.cluster_name}-nat-instance-route"
  dest_range        = var.dest_range
  network           = var.vpc
  next_hop_instance = google_compute_instance.nat_gateway.self_link
  tags              = ["use-nat"]
  priority          = 0
}

# NAT Firewall
resource "google_compute_firewall" "nat_instance_firewall_traffic" {
  name    = "${var.cluster_name}-traffic-to-nat"
  network = var.vpc

  allow {
    protocol = "tcp"
    ports    = var.nat_instance_fw_ports
  }

  source_ranges = var.nat_instance_ingress_gke
  target_tags   = ["nat"]
}

resource "google_compute_firewall" "nat_instance_ssh" {
  name    = "${var.cluster_name}-ssh-to-nat"
  network = var.vpc

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["nat"]
}

# NAT instance
resource "google_compute_instance" "nat_gateway" {
  name         = "${var.cluster_name}-nat-instance"
  zone         = "${var.region}-a"
  machine_type = var.instance_type

  # Define the boot disk
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12" # Using the image from the 'debian-cloud' project
      size  = 50 # Boot disk size in GB
    }
  }

  # Network interface and subnetwork configuration
  network_interface {
    network = var.vpc
    subnetwork = var.subnet
    network_ip = google_compute_address.nat_reserved_private_ip.address
    # Setting can_ip_forward for NAT
    access_config {
      // Leave empty to assign an ephemeral IP
    }
  }

  # Metadata for IP forwarding
  can_ip_forward = true

  # Tags
  tags = ["nat"]
  metadata = {
    # Startup script configuring the IPTABLES routing
    startup-script = <<EOF
#!/bin/bash
# Your custom script commands
sysctl -w net.ipv4.ip_forward=1
echo "Adding routing for the interface $(ip route | grep default | awk '{print $5}' | head -n 1)" > /tmp/debug.log
iptables -t nat -A POSTROUTING -o $(ip route | grep default | awk '{print $5}' | head -n 1) -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
EOF
  }
}