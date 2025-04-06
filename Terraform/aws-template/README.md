# K2VIEW AWS Infrastructure Blueprint

## Overview
This blueprint provides a complete infrastructure setup for K2VIEW applications on AWS using Terraform. It creates a production-ready EKS cluster with all necessary components including networking, storage, DNS, and K2VIEW specific configurations.

## Features
- **VPC Setup**: Creates a VPC with public and private subnets across multiple availability zones
- **EKS Cluster**: Deploys a managed Kubernetes cluster with configurable node groups
- **Storage Solutions**: 
  - EBS storage classes for block storage
  - EFS storage class for shared filesystem (optional)
- **Network Components**:
  - Public and private subnets
  - NAT gateways
  - Internet gateway
  - DNS configuration with Route53 (optional)
- **Security**:
  - IRSA (IAM Roles for Service Accounts) setup
  - Network policies and security groups
- **Additional Components**:
  - Ingress Controller (NGINX)
  - Cluster Autoscaler
  - K2VIEW Agent deployment

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- kubectl
- helm

## Quick Start

1. **Configure Variables**
   Update the values in `terraform.tfvars`:
   ```hcl
      region                 = "eu-central-1"
      availability_zones     = ["euc1-az1", "euc1-az2"]
      cluster_name           = "CLUSTER-NAME"
      domain                 = "CLUSTER-NAME.SUBDOMAIN.DOMAIN.com"
      mailbox_id             = "aaa-bbb-ccc-ddd-eee"
      mailbox_url            = "https://cloud.k2view.com/api/mailbox"      
      eks_max_worker_count   = 3
   ```
   - For more advanced configuration and variable management, refer to variables.tf

2. **Initialize Terraform**
   ```bash
   # Ensure AWS CLI access is configured with appropriate credentials or temporary access token exported
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
- `cluster_name`: Name of your EKS cluster
- `region`: AWS region to deploy in
- `domain`: Domain name for ingress (if DNS is enabled)

### Optional Variables
- `mailbox_id`: K2VIEW Cloud mailbox ID
- `vpc_cidr`: VPC CIDR block (default: "10.5.0.0/16")
- `kubernetes_version`: EKS version (default: "1.32")
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

1. Create your module in the `modules/aws` directory
2. Add the module reference in `main.tf`:
   ```hcl
   module "new_module" {
     source = "../modules/aws/new_module"
     # Add required variables
   }
   ```
3. Add any new variables to `variables.tf`
4. Update documentation

## Maintenance

### Updating EKS Version
1. Update `kubernetes_version` in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Apply updates with `terraform apply`

### Adding Node Groups
1. Modify the `eks` module configuration in `main.tf`
2. Add new node group configurations in `terraform.tfvars`

### Scaling
- Adjust `eks_min_worker_count` and `eks_max_worker_count` in `terraform.tfvars`
- Cluster Autoscaler will manage scaling within these limits

## Troubleshooting

### Common Issues
1. **Access Issues**
   - Verify AWS credentials
   - Check IAM permissions
   - Ensure correct VPC and subnet configurations

2. **EKS Connection**
   - Update kubeconfig: `aws eks update-kubeconfig --region <region> --name <cluster_name>`
   - Check security group rules

3. **DNS Issues**
   - Verify Route53 zone configuration
   - Check DNS record propagation

## Additional Resources
- [Detailed Terraform Documentation](./Terraform.md)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [K2VIEW Documentation](https://k2view.com/documentation)

## Support
For issues and support, please contact the K2VIEW DevOps team or create an issue in the repository.