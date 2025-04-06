# K2VIEW GCP Infrastructure Blueprint

## Overview
This blueprint provides a complete infrastructure setup for K2VIEW applications on GCP using Terraform. 
It creates a production-ready GKE cluster with all necessary components including networking, storage, DNS, and K2VIEW specific configurations.

## Features
- **VPC Setup**: Creates a VPC with subnets across multiple regions
- **GKE Cluster**: Deploys a managed Kubernetes cluster with configurable node pools
- **Storage Solutions**: 
  - Persistent Disk storage classes for block storage
  - Cloud Filestore for shared filesystem (optional)
- **Network Components**:
  - VPC networks
  - Cloud NAT
  - Cloud Router
- **Security**:
  - IAM Service Account setup
  - Firewall rules and network tags
- **Additional Components**:
  - Ingress Controller (NGINX)
  - Cluster Autoscaler
  - K2VIEW Agent deployment
  - DNS configuration with Cloud DNS (optional)

## Prerequisites
- gcloud CLI configured with appropriate credentials
- Terraform >= 1.0
- kubectl
- helm

## Quick Start

1. **Configure Variables**
   Update the values in `terraform.tfvars`:
   ```hcl
      region                 = "europe-west1"
      zones                  = ["europe-west1-b", "europe-west1-c"]
      cluster_name           = "CLUSTER-NAME"
      domain                 = "CLUSTER-NAME.SUBDOMAIN.DOMAIN.com"
      mailbox_id             = "aaa-bbb-ccc-ddd-eee"
      mailbox_url            = "https://cloud.k2view.com/api/mailbox"      
      gke_max_node_count     = 3
   ```
   - For more advanced configuration and variable management, refer to variables.tf

2. **Initialize Terraform**
   ```bash
   # Ensure gcloud CLI access is configured with appropriate credentials or temporary access token exported
   terraform init
   ```

3. **Review the Plan**
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**
   ```bash
   terraform apply
   ```

## Configuration

### Required Variables
- `cluster_name`: Name of your GKE cluster
- `region`: GCP region to deploy in
- `domain`: Domain name for ingress (if DNS is enabled)

### Optional Variables
- `mailbox_id`: K2VIEW Cloud mailbox ID
- `vpc_cidr`: VPC CIDR block (default: "10.5.0.0/16")
- `kubernetes_version`: GKE version (default: "1.32")
- See [Terraform Documentation](./Terraform.md) for all available variables

## Module Structure
```
├── main.tf # Main Terraform configuration
├── variables.tf # Variable definitions
├── providers.tf # Provider configurations
├── terraform.tfvars # Variable values
└── Terraform.md # Module documentation
```

## Adding New Modules

1. Create your module in the `modules/gcp` directory
2. Add the module reference in `main.tf`:
   ```hcl
   module "new_module" {
     source = "../modules/gcp/new_module"
     # Add required variables
   }
   ```
3. Add any new variables to `variables.tf`
4. Update documentation

## Maintenance

### Updating GKE Version
1. Update `kubernetes_version` in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Apply updates with `terraform apply`

### Adding Node Groups
1. Modify the `gke` module configuration in `main.tf`
2. Add new node group configurations in `terraform.tfvars`

### Scaling
- Adjust `gke_min_worker_count` and `gke_max_worker_count` in `terraform.tfvars`
- Cluster Autoscaler will manage scaling within these limits

## Troubleshooting

### Common Issues
1. **Access Issues**
   - Verify GCP credentials
   - Check IAM permissions
   - Ensure correct VPC and subnet configurations

2. **GKE Connection**
   - Update kubeconfig: `gcloud container clusters get-credentials CLUSTER_NAME --region REGION`
   - Check firewall rules and network tags

3. **DNS Issues**
   - Verify Cloud DNS configuration
   - Check DNS record propagation

## Additional Resources
- [Detailed Terraform Documentation](./Terraform.md)
- [GCP GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [K2VIEW Documentation](https://k2view.com/documentation)

## Support
For issues and support, please contact the K2VIEW DevOps team or create an issue in the repository.
