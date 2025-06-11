# DevOps Portfolio Infrastructure

This project deploys a scalable AWS infrastructure for a portfolio website using Terraform. The setup includes a VPC with public and private subnets, an Application Load Balancer (ALB), an Auto Scaling Group (ASG) of EC2 instances running Apache, a bastion host, an S3 bucket for assets, and CloudWatch monitoring. The infrastructure is designed to demonstrate DevOps best practices, including high availability, scalability, and security.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Outputs](#outputs)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Scalable Infrastructure**: Auto Scaling Group with dynamic scaling policies based on CPU utilization.
- **High Availability**: Multi-AZ VPC with public and private subnets, NAT Gateways, and ALB.
- **Secure Access**: Bastion host for SSH access, security groups, and S3 bucket with restricted access.
- **Monitoring**: CloudWatch for metrics, logs, and alarms.
- **Web Application**: Portfolio website hosted on Apache, displaying instance and infrastructure details.
- **Optional HTTPS**: Support for SSL/TLS certificates via AWS Certificate Manager.
- **IaC**: Fully managed with Terraform for reproducible deployments.

## Architecture

- **VPC**: Custom CIDR with 3 public and 3 private subnets across multiple AZs.
- **Networking**: Internet Gateway, NAT Gateways, and route tables for public/private traffic.
- **Compute**: EC2 instances in an ASG Group, with a bastion host in a public subnet.
- **Load Balancing**: ALB with HTTP/HTTPS listeners and health checks.
- **Storage**: S3 bucket for application assets with versioning and encryption.
- **Security**: IAM roles, security groups, and SSH key pair for access control.
- **Monitoring**: CloudWatch logs for Apache, metrics for CPU/disk/memory, and scaling alarms.

## Prerequisites

- **AWS Account**: With programmatic access (Access Key ID and Secret Access Key).
- **Terraform**: Version >= 1.0.
- **GitHub Account**: For cloning the repository and optional Codespaces usage.
- **SSH Key Pair**: Public key (ssh-key.pub) for EC2 access.
- **Optional**: ACM certificate ARN for HTTPS and a registered domain for Route 53.

## Project Structure

```
devops-portfolio/
├── provider.tf          # Terraform provider configuration
├── variables.tf         # Input variables with defaults and validations
├── main.tf              # Core infrastructure resources
├── outputs.tf           # Output variables for deployed resources
├── userdata.sh          # EC2 user data script for web server setup
├── ssh-key.pub          # Public SSH key for EC2 access
├── .gitignore           # Excludes sensitive and temporary files
└── README.md            # Project documentation
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/devops-portfolio.git
cd devops-portfolio
```

### 2. Install Terraform

Follow the official Terraform installation guide or install in a GitHub Codespace:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

### 3. Configure AWS Credentials

Install AWS CLI:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Configure credentials:

```bash
aws configure
```

Enter your Access Key ID, Secret Access Key, region (us-east-1), and output format (json).

### 4. Prepare SSH Key

Ensure ssh-key.pub contains your public SSH key. Generate a key pair if needed:

```bash
ssh-keygen -t rsa -b 4096 -f ssh-key -N ""
```

### 5. Initialize Terraform

```bash
terraform init
```

### 6. Customize Variables (Optional)

Override defaults in a terraform.tfvars file:

```hcl
aws_region          = "us-east-1"
project_name        = "my-devops-portfolio"
environment         = "production"
owner               = "YourName"
ssl_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxx" # Optional
domain_name         = "example.com" # Optional
```

### 7. Deploy Infrastructure

Generate a plan:

```bash
terraform plan -out=tfplan
```

Apply the plan:

```bash
terraform apply tfplan
```

## Usage

- **Access the Website**: Use the application_url output (e.g., http://<alb-dns-name>) to view the portfolio website.
- **SSH to Bastion**: Connect using the bastion_public_ip:
  ```bash
  ssh -i ssh-key ec2-user@<bastion_public_ip>
  ```
- **Monitor Resources**: Check CloudWatch for logs (/aws/ec2/devops-portfolio) and metrics.
- **Scale Infrastructure**: Simulate load to trigger ASG scaling based on CPU alarms.

## Outputs

Key outputs include:

- **application_url**: URL to access the portfolio website.
- **load_balancer_dns_name**: ALB DNS name.
- **bastion_public_ip**: Public IP of the bastion host.
- **s3_bucket_name**: Name of the S3 bucket.
- **autoscaling_group_name**: Name of the ASG.

See outputs.tf for all outputs.

## Cleanup

To avoid AWS charges, destroy the infrastructure:

```bash
terraform destroy
```

Confirm with `yes`.

## Troubleshooting

- **Terraform Errors**: Verify AWS credentials and provider versions. Re-run terraform init.
- **Website Not Loading**: Check ALB health checks, security groups, and userdata.sh execution.
- **SSH Issues**: Ensure ssh-key.pub matches your private key and security groups allow SSH.
- **Scaling Issues**: Confirm CloudWatch alarms and ASG policies are triggered.

## Contributing

Contributions are welcome! Please:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See LICENSE for details.
