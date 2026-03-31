# Azure Network Modules
Collection of Terraform modules for provisioning Azure networking resources for AKS clusters.

| Module | Description |
|--------|-------------|
| [private-network](./private-network/) | Full network stack: VNet, subnet, NAT gateway, and optional route table |
| [vnet](./vnet/) | Virtual network with NAT gateway and optional route table (no subnet) |
| [subnet](./subnet/) | Subnet within an existing VNet, with NAT gateway and route table associations |
| [dns](./dns/) | Public DNS zone with wildcard and root A records |
