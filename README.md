# 🚀 terraform Based Contact Management System

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

**Containerized Contact Management Application with Automated AWS Infrastructure**

[Architecture](#-architecture) • [Prerequisites](#-prerequisites) • [Deployment](#-deployment) • [Usage](#-usage)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Project Structure](#-project-structure)
- [Deployment Workflow](#-deployment-workflow)
- [Infrastructure Details](#-infrastructure-details)
- [Docker Container](#-docker-container)
- [Security](#-security)
- [Maintenance](#-maintenance)
- [Cost Estimate](#-cost-estimate)
- [Cleanup](#-cleanup)

---

## 🎯 Overview

This project provisions a complete AWS infrastructure using **Terraform** to run a **Dockerized Contact Management Application**. The application runs in a Docker container on an EC2 instance and connects to an RDS MySQL database for data persistence.

### Key Highlights

- 🏗️ **Infrastructure as Code** - Complete AWS setup with Terraform
- 🐳 **Containerized Deployment** - Application runs in Docker container
- 🗄️ **Managed Database** - AWS RDS MySQL for reliable data storage
- ☁️ **Cloud-Native** - Deployed on AWS with best practices
- 🔄 **Automated Provisioning** - One-command infrastructure deployment

---

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Cloud (eu-north-1)                       │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │              VPC (10.0.0.0/16)                            │ │
│  │                                                           │ │
│  │  ┌──────────────────────┐    ┌──────────────────────┐   │ │
│  │  │  Public Subnet A     │    │  Public Subnet B     │   │ │
│  │  │  (eu-north-1a)       │    │  (eu-north-1b)       │   │ │
│  │  │  10.0.1.0/24         │    │  10.0.2.0/24         │   │ │
│  │  │                      │    │                      │   │ │
│  │  │  ┌────────────────┐  │    │  ┌────────────────┐  │   │ │
│  │  │  │ EC2 Instance   │  │    │  │ RDS MySQL      │  │   │ │
│  │  │  │ t3.small       │  │    │  │ db.t3.micro    │  │   │ │
│  │  │  │                │  │    │  │                │  │   │ │
│  │  │  │ ┌────────────┐ │  │    │  │ Port: 3306     │  │   │ │
│  │  │  │ │  Docker    │ │◄─┼────┼──┤ Engine: 8.0    │  │   │ │
│  │  │  │ │ Container  │ │  │    │  │ Storage: 20GB  │  │   │ │
│  │  │  │ └────────────┘ │  │    │  └────────────────┘  │   │ │
│  │  │  │                │  │    │                      │   │ │
│  │  │  │ User Data:     │  │    │                      │   │ │
│  │  │  │ - Install Docker│ │    │                      │   │ │
│  │  │  │ - Pull Image   │  │    │                      │   │ │
│  │  │  │ - Run Container│  │    │                      │   │ │
│  │  │  └────────┬───────┘  │    │                      │   │ │
│  │  │           │          │    │                      │   │ │
│  │  └───────────┼──────────┘    └──────────────────────┘   │ │
│  │              │                                           │ │
│  │         ┌────▼──────┐                                    │ │
│  │         │   IGW     │                                    │ │
│  │         │ (Gateway) │                                    │ │
│  │         └───────────┘                                    │ │
│  │              │                                           │ │
│  └──────────────┼───────────────────────────────────────────┘ │
│                 │                                             │
└─────────────────┼─────────────────────────────────────────────┘
                  │
                  ▼
            Internet Users
         (HTTP Port 80)
```

### Component Flow

1. **User Request** → Internet Gateway → EC2 Instance (Port 80)
2. **EC2 Instance** → Runs Docker Container with application
3. **Docker Container** → Connects to RDS MySQL (Port 3306)
4. **RDS MySQL** → Stores and retrieves contact data

---

## 📦 Prerequisites

### Required Tools

- ✅ **Terraform** (v1.0+) - [Install Guide](https://developer.hashicorp.com/terraform/downloads)
- ✅ **AWS CLI** - [Install Guide](https://aws.amazon.com/cli/)
- ✅ **Terraform Cloud Account** - [Sign Up](https://app.terraform.io/)
- ✅ **Git** - For version control

### AWS Requirements

```yaml
Account: Active AWS Account
Credentials: AWS Access Key & Secret Key
Permissions:
  - EC2: Full Access
  - VPC: Full Access
  - RDS: Full Access
  - IAM: Read Access
Region: eu-north-1 (or modify in provider)
```

### Terraform Cloud Setup

```yaml
Organization: vinsys
Project: Learn Terraform
Workspace: learn-terraform-aws-get-started
```

---

## 📁 Project Structure

```
terraform-contact-management/
│
├── main.tf                    # Main Terraform configuration
├── README.md                  # This file
├── terraform.tfvars           # Variable values (optional)
├── outputs.tf                 # Output definitions (optional)
```

---

## 🚀 Deployment Workflow

### Step 1: Configure AWS Credentials

```bash
# Configure AWS CLI
aws configure

# Enter your credentials
AWS Access Key ID: YOUR_ACCESS_KEY
AWS Secret Access Key: YOUR_SECRET_KEY
Default region name: eu-north-1
Default output format: json
```

### Step 2: Prepare Docker Image

**Option A: Use Public Docker Image**
```bash
# Update user_data in main.tf to pull your image
docker pull your-dockerhub-username/contact-app:latest
```

**Option B: Build and Push Custom Image**
```bash
# Build your Docker image
docker build -t contact-app .

# Tag for registry
docker tag contact-app:latest your-registry/contact-app:latest

# Push to registry (Docker Hub, ECR, etc.)
docker push your-registry/contact-app:latest
```

### Step 3: Initialize Terraform

```bash
# Clone repository
git clone <your-repo-url>
cd terraform-contact-management

# Initialize Terraform
terraform init
```

**Expected Output:**
```
Initializing Terraform Cloud...
Initializing provider plugins...
Terraform has been successfully initialized!
```

### Step 4: Plan Infrastructure

```bash
# Review planned changes
terraform plan
```

This will show:
- ✅ 12 resources to be created
- VPC, Subnets, Security Groups, EC2, RDS, etc.

### Step 5: Deploy Infrastructure

```bash
# Apply configuration
terraform apply

# Type 'yes' when prompted
```

⏱️ **Estimated Time:** 8-12 minutes

**Deployment Progress:**
```
1. Creating VPC and networking... ✓
2. Setting up subnets and IGW... ✓
3. Configuring security groups... ✓
4. Launching EC2 instance... ✓
5. Provisioning RDS database... ✓ (slowest step)
6. Running user_data script... ✓
   - Installing Docker
   - Pulling container image
   - Starting application
```

### Step 6: Verify Deployment

```bash
# Get EC2 public IP
terraform output ec2_public_ip

# Check EC2 instance status
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*app*" \
  --query 'Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]'

# SSH into instance (optional)
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>

# Check Docker container status
sudo docker ps
```

### Step 7: Access Application

```bash
# Open in browser
http://<EC2_PUBLIC_IP>
```

---

## 🛠️ Infrastructure Details

### Network Configuration

| Component | Details | Purpose |
|-----------|---------|---------|
| **VPC** | `10.0.0.0/16` | Isolated network environment |
| **Public Subnet A** | `10.0.1.0/24` (AZ-1a) | Hosts EC2 instance |
| **Public Subnet B** | `10.0.2.0/24` (AZ-1b) | Hosts RDS database |
| **Internet Gateway** | Attached to VPC | Public internet connectivity |
| **Route Table** | Routes to IGW | Traffic routing to internet |

### Compute Resources

| Resource | Specification | Configuration |
|----------|--------------|---------------|
| **EC2 Instance** | t3.small | 2 vCPU, 2 GB RAM |
| **AMI** | ami-0d2aad4794ad02001 | Ubuntu (eu-north-1) |
| **Storage** | EBS GP2 | Default 8 GB root volume |
| **Public IP** | Auto-assigned | Accessible from internet |

### Database Configuration

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Engine** | MySQL 8.0 | Latest stable version |
| **Instance Class** | db.t3.micro | 1 vCPU, 1 GB RAM |
| **Storage** | 20 GB GP2 | General Purpose SSD |
| **Username** | admin | Default admin user |
| **Multi-AZ** | Disabled | Single AZ for cost savings |
| **Backup** | Skip final snapshot | For dev/test environments |

### Security Groups

**EC2 Security Group (ec2-sg)**
```hcl
Ingress:
  - Port 80 (HTTP)  → 0.0.0.0/0  # Web traffic
  - Port 22 (SSH)   → 0.0.0.0/0  # Admin access

Egress:
  - All traffic     → 0.0.0.0/0  # Outbound internet
```

**RDS Security Group (rds-sg)**
```hcl
Ingress:
  - Port 3306 (MySQL) → ec2-sg only  # Database access from EC2

Egress:
  - All traffic       → 0.0.0.0/0    # Outbound internet
```

---

## 🐳 Docker Container

### User Data Script

The EC2 instance automatically:

1. **Updates system packages**
2. **Installs Docker Engine**
3. **Pulls your Docker image**
4. **Runs container with environment variables**

### Example User Data (Complete Version)

```bash
#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install Docker
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Wait for RDS to be ready
sleep 60

# Pull Docker image
docker pull your-registry/contact-app:latest

# Run container
docker run -d \
  --name contact-app \
  --restart always \
  -p 80:8080 \
  -e DB_HOST=${aws_db_instance.db.endpoint} \
  -e DB_USER=admin \
  -e DB_PASSWORD=Soham123456 \
  -e DB_NAME=contacts \
  your-registry/contact-app:latest

# Check container status
docker ps
```

### Container Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `DB_HOST` | RDS endpoint | Database connection |
| `DB_USER` | admin | Database username |
| `DB_PASSWORD` | Soham123456 | Database password |
| `DB_NAME` | contacts | Database name |
| `PORT` | 8080 | Internal container port |

### Docker Image Requirements

Your Docker image should:
- ✅ Expose port 8080 (mapped to host port 80)
- ✅ Accept environment variables for DB connection
- ✅ Handle MySQL connection gracefully
- ✅ Include proper error handling and logging

---

## 🔒 Security

### ⚠️ Current Security Issues

<table>
<tr>
<td width="50%" valign="top">

#### 🔴 Critical Issues

- **Hardcoded DB Password** in Terraform code
- **SSH Port 22** open to `0.0.0.0/0`
- **RDS Publicly Accessible** (security risk)
- **No SSL/TLS** for HTTP traffic
- **No secrets management**

</td>
<td width="50%" valign="top">

#### 🟡 Medium Issues

- No CloudWatch monitoring
- No automated backups
- No encryption at rest
- Single AZ deployment
- No WAF protection

</td>
</tr>
</table>

### 🛡️ Recommended Security Improvements

#### 1. Use AWS Secrets Manager

```hcl
# Create secret
resource "aws_secretsmanager_secret" "db_password" {
  name = "contact-app-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

# Reference in RDS
resource "aws_db_instance" "db" {
  password = aws_secretsmanager_secret_version.db_password.secret_string
}
```

#### 2. Restrict SSH Access

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["YOUR_IP/32"]  # Your IP only
}
```

#### 3. Make RDS Private

```hcl
resource "aws_db_instance" "db" {
  publicly_accessible = false  # Change to false
}
```

#### 4. Add Application Load Balancer + SSL

```hcl
resource "aws_lb" "app" {
  name               = "contact-app-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "your-certificate-arn"
}
```

---

## 🔧 Maintenance

### Monitoring

```bash
# Check EC2 instance
aws ec2 describe-instances --instance-ids <INSTANCE_ID>

# Check RDS status
aws rds describe-db-instances --db-instance-identifier <DB_ID>

# View CloudWatch logs (if configured)
aws logs tail /aws/ec2/contact-app --follow
```

### SSH into EC2

```bash
# Connect to instance
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>

# Check Docker logs
sudo docker logs contact-app -f

# Restart container
sudo docker restart contact-app

# Update container image
sudo docker pull your-registry/contact-app:latest
sudo docker stop contact-app
sudo docker rm contact-app
# Run docker run command again
```

### Database Maintenance

```bash
# Connect to RDS from EC2
mysql -h <RDS_ENDPOINT> -u admin -p

# Show databases
SHOW DATABASES;

# Use contacts database
USE contacts;

# Show tables
SHOW TABLES;

# Backup database
mysqldump -h <RDS_ENDPOINT> -u admin -p contacts > backup.sql
```

### Update Application

```bash
# Build new image
docker build -t contact-app:v2 .

# Push to registry
docker push your-registry/contact-app:v2

# SSH to EC2 and update
ssh ubuntu@<EC2_IP>
sudo docker pull your-registry/contact-app:v2
sudo docker stop contact-app
sudo docker rm contact-app
sudo docker run -d --name contact-app -p 80:8080 \
  -e DB_HOST=... \
  your-registry/contact-app:v2
```

---

## 💰 Cost Estimate

### Monthly AWS Costs (eu-north-1 Region)

| Service | Configuration | Cost/Month |
|---------|---------------|------------|
| **EC2 (t3.small)** | On-Demand, 24/7 | ~$15.00 |
| **RDS (db.t3.micro)** | Single-AZ, 24/7 | ~$13.00 |
| **EBS Storage** | 8 GB (EC2 root) | ~$0.80 |
| **RDS Storage** | 20 GB GP2 | ~$2.30 |
| **Data Transfer** | Minimal (<1 GB) | ~$0.50 |
| **Elastic IP** | If using static IP | ~$3.65 |
| **Total Estimated** | | **~$32-35/month** |

### Cost Optimization Tips

💡 **Reduce Costs:**
- Use `terraform destroy` when not needed
- Consider Reserved Instances for production (save 30-70%)
- Use t3.micro for EC2 in dev/test (~$7.5/month)
- Enable RDS stop/start for dev environments
- Use spot instances for non-critical workloads

---

## 🗑️ Cleanup

### Destroy All Resources

```bash
# Destroy infrastructure
terraform destroy

# Confirm with 'yes'
```

**Resources that will be deleted:**
- ✓ EC2 Instance
- ✓ RDS Database
- ✓ VPC and all networking
- ✓ Security Groups
- ✓ Internet Gateway
- ✓ Route Tables

### Verify Cleanup

```bash
# Check remaining resources
aws ec2 describe-instances --region eu-north-1
aws rds describe-db-instances --region eu-north-1
aws ec2 describe-vpcs --region eu-north-1
```

---

## 🐛 Troubleshooting

<details>
<summary><b>Container not running on EC2?</b></summary>

```bash
# SSH into EC2
ssh -i your-key.pem ubuntu@<EC2_IP>

# Check Docker service
sudo systemctl status docker

# Check container status
sudo docker ps -a

# View container logs
sudo docker logs contact-app

# Check user_data execution
sudo cat /var/log/cloud-init-output.log
```
</details>

<details>
<summary><b>Cannot connect to RDS from container?</b></summary>

```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids <RDS_SG_ID>

# Test connection from EC2
mysql -h <RDS_ENDPOINT> -u admin -p

# Check RDS endpoint
aws rds describe-db-instances \
  --db-instance-identifier <DB_ID> \
  --query 'DBInstances[0].Endpoint'

# Verify environment variables in container
sudo docker exec contact-app env | grep DB_
```
</details>

<details>
<summary><b>Terraform apply fails?</b></summary>

```bash
# Check Terraform state
terraform state list

# Validate configuration
terraform validate

# Check for resource conflicts
terraform plan

# Refresh state
terraform refresh

# Force unlock if needed
terraform force-unlock <LOCK_ID>
```
</details>

<details>
<summary><b>User data script not executing?</b></summary>

```bash
# Check cloud-init logs
ssh ubuntu@<EC2_IP>
sudo cat /var/log/cloud-init.log
sudo cat /var/log/cloud-init-output.log

# Check script execution
sudo systemctl status cloud-final

# Manually run commands if needed
sudo bash /var/lib/cloud/instance/scripts/part-001
```
</details>

---

## 📚 Additional Resources

### Terraform
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### Docker
- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose Guide](https://docs.docker.com/compose/)

### AWS
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Amazon RDS User Guide](https://docs.aws.amazon.com/rds/)
- [EC2 User Data Scripts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📝 License

This project is for educational purposes. Use at your own risk.

---

<div align="center">

**Built with ❤️ using Terraform, Docker & AWS**

![Infrastructure as Code](https://img.shields.io/badge/Infrastructure-as_Code-blue?style=flat-square)
![Containerized](https://img.shields.io/badge/Deployment-Containerized-green?style=flat-square)
![Cloud Native](https://img.shields.io/badge/Architecture-Cloud_Native-orange?style=flat-square)

⭐ Star this repo if you find it helpful!

</div>
