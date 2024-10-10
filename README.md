# Terraform AWS VPC Setup

This Terraform module sets up an AWS Virtual Private Cloud (VPC) along with an Internet Gateway and public/private subnets as specified in the variables.

## Variables

The following variables are used for the execution of the Terraform script:

- **aws_region**: The AWS region where resources will be created.
- **vpc_cidr**: CIDR block for the VPC.
- **vpc_name**: The name of the VPC.
- **public_subnets**: List of public subnet CIDRs.
- **private_subnets**: List of private subnet CIDRs.
- **availability_zones**: List of Availability Zones to be used.
- **gateway_name**: The name of the Internet Gateway.

## Example `terraform.tfvars`

Below is an example of a `terraform.tfvars` file with sample values:

```hcl
# AWS region where resources will be created
aws_region = "us-east-1"

# CIDR block for the VPC
vpc_cidr = "10.0.0.0/16"

# Name of the VPC
vpc_name = "demo-vpc"

# Public Subnets CIDR blocks
public_subnets = [
  "10.0.1.0/24", # Availability Zone 1
  "10.0.2.0/24", # Availability Zone 2
  "10.0.3.0/24"  # Availability Zone 3
]

# Private Subnets CIDR blocks
private_subnets = [
  "10.0.4.0/24", # Availability Zone 1
  "10.0.5.0/24", # Availability Zone 2
  "10.0.6.0/24"  # Availability Zone 3
]

# Availability Zones to be used
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

gateway_name = "demo-gateway"
```

### Terraform Commands
To deploy the infrastructure, follow these steps:

Ensure you have Terraform installed.

Clone this repository or download the Terraform configuration files.

Create a demo.tfvars file with your desired values as shown above.

Initialize Terraform:

```bash
terraform init
```

Plan the deployment:
```bash
terraform plan -var-file="demo.tfvars" -out=<planname>
```

Apply the changes:
```bash
terraform apply -var-file="demo.tfvars"
```