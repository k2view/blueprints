# K2VIEW Azure Infrastructure Blueprint

## Overview
This blueprint provides a complete infrastructure setup for K2VIEW applications on Azure using Terraform. 
It creates a production-ready AKS cluster with all necessary components including networking, storage, DNS, and K2VIEW specific configurations.
 - Feel free to modify, change, or manage the code as you see fit for your use case.



## Features
- **VNet Setup**: Creates a VNet with subnets across multiple availability zones
- **AKS Cluster**: Deploys a managed Kubernetes cluster with configurable node pools
- **Storage Solutions**: 
  - Azure Disk storage classes for block storage
  - Azure Files storage class for shared filesystem (optional)
- **Network Components**:
  - Subnets
  - Network Security Groups
  - Public IP addresses
- **Security**:
  - Azure AD integration
  - Network security rules
- **Additional Components**:
  - Ingress Controller (NGINX)
  - Cluster Autoscaler
  - K2VIEW Agent deployment
  - DNS configuration with Azure DNS (optional)

## Prerequisites
- Azure CLI configured with appropriate credentials
- Terraform >= 1.0
- kubectl
- helm

## Quick Start

1. **Configure Variables**
   Update the values in `terraform.tfvars`:
   ```hcl
      region                 = "eastus"
      resource_group         = "RESOURCE-GROUP"
      cluster_name           = "CLUSTER-NAME"
      domain                 = "CLUSTER-NAME.SUBDOMAIN.DOMAIN.com"
      mailbox_id             = "aaa-bbb-ccc-ddd-eee"
      mailbox_url            = "https://cloud.k2view.com/api/mailbox"      
      aks_node_count         = 3
   ```
   - For more advanced configuration and variable management, refer to variables.tf

2. **Initialize Terraform**
   ```bash
   # Ensure Azure CLI access is configured with appropriate credentials.
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
- `cluster_name`: Name of your AKS cluster
- `resource_group`: Azure resource group to deploy in
- `domain`: Domain name for ingress (if DNS is enabled)

### Optional Variables
- `mailbox_id`: K2VIEW Cloud mailbox ID
- `vnet_cidr`: VNet CIDR block (default: "10.0.0.0/16")
- `kubernetes_version`: AKS version (default: "1.32")
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

1. Create your module in the `modules/azure` directory
2. Add the module reference in `main.tf`:
   ```hcl
   module "new_module" {
     source = "../modules/azure/new_module"
     # Add required variables
   }
   ```
3. Add any new variables to `variables.tf`
4. Update documentation

## Maintenance

### Updating AKS Version
1. Update `kubernetes_version` in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Apply updates with `terraform apply`

### Adding Node Groups
1. Modify the `node_groups` module configuration in `main.tf`
2. Add new node group configurations in `terraform.tfvars`

### Scaling
- Adjust `node_min_count` and `node_max_count` in `terraform.tfvars`
- Cluster Autoscaler will manage scaling within these limits

## Troubleshooting

### Common Issues
1. **Access Issues**
   - Verify Azure credentials
   - Check IAM permissions
   - Ensure correct VNet and subnet configurations

2. **AKS Connection**
   - Update kubeconfig: `az aks get-credentials --resource-group <resource_group> --name <cluster_name>`
   - Check network security group rules

3. **DNS Issues**
   - Verify Azure DNS zone configuration
   - Check DNS record propagation

## Additional Resources
- [Detailed Terraform Documentation](./Terraform.md)
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [K2VIEW Documentation](https://k2view.com/documentation)

## Support
For issues and support, please contact the K2VIEW DevOps team or create an issue in the repository.
