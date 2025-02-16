# Building a Scalable AWS Infrastructure with Terraform: A Comprehensive Guide

In this article, we will explore how to build a scalable and secure AWS infrastructure using **Terraform**, an open-source Infrastructure as Code (IaC) tool. The architecture includes a Virtual Private Cloud (VPC), subnets, an Application Load Balancer (ALB), EC2 instances, and an RDS MySQL database. We'll break down each file in the Terraform configuration and explain its role in the overall infrastructure.

---

## Why Use Terraform?

Before diving into the details, let’s briefly discuss why Terraform is an excellent choice for managing cloud infrastructure:

- **Infrastructure as Code (IaC)**: Define your infrastructure in code, making it repeatable, version-controlled, and easy to modify.
- **Automation**: Automate the provisioning and management of resources, reducing manual errors.
- **Reusability**: Easily replicate the same infrastructure across multiple environments (development, staging, production).
- **Scalability**: Scale your infrastructure by modifying configurations and reapplying them.

---

## Architecture Overview

The architecture consists of the following components:

1. **VPC (Virtual Private Cloud)**:
   - CIDR block: `10.0.0.0/16`
   - Acts as the backbone for all other resources.

2. **Subnets**:
   - **Public Subnet (`10.0.1.0/24`)**: Hosts the ALB, which routes traffic to the private EC2 instances.
   - **Private Subnet A (`10.0.2.0/24`)**: Contains two EC2 instances running the application logic.
   - **Private Subnet B (`10.0.3.0/24`)**: Hosts the RDS MySQL database instance.

3. **Internet Gateway**:
   - Provides internet access to resources in the public subnet.

4. **Security Groups**:
   - Configured to allow necessary inbound and outbound traffic while maintaining security.

5. **Application Load Balancer (ALB)**:
   - Routes incoming HTTP traffic to the EC2 instances in Private Subnet A.

6. **EC2 Instances**:
   - Two web servers running the application.

7. **RDS MySQL Database**:
   - A managed relational database service for storing application data.

8. **Terraform**:
   - Manages the entire infrastructure as code.

---

## File Structure

The Terraform configuration is split into multiple files for better organization. Below is the directory structure:

```bash
terraform/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── security_groups.tf
├── ec2_instances.tf
├── rds.tf
├── alb.tf
└── outputs.tf
```

Let’s examine each file in detail, along with explanations of its purpose and functionality.

---

### 1. **provider.tf**

This file configures the AWS provider, specifying the region and authentication credentials.

```hcl
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}
```

#### **Explanation**

- **Purpose**: Defines the AWS provider and authenticates Terraform with your AWS account.
- **Key Variables**:
  - `region`: Specifies the AWS region where resources will be deployed (e.g., `us-east-1`).
  - `access_key` and `secret_key`: AWS credentials for authentication. These are typically stored securely and referenced via variables or environment variables.
- **Why Modularize?**: By separating the provider configuration, you can easily switch regions or accounts without modifying the rest of the code.

---

### 2. **variables.tf**

This file defines all the variables used in the Terraform configuration.

```hcl
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for Private Subnet A"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for Private Subnet B"
  type        = string
  default     = "10.0.3.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-06c68f701d8090592"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = "my-ec2-key"
}

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage size for the RDS database"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "application_db"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

### **Explanation**

- **Purpose**: Centralizes configurable parameters, making the infrastructure reusable and customizable.
- **Key Variables**:
  - `vpc_cidr_block`, `public_subnet_cidr`, etc.: Define network ranges.
  - `ami_id`, `instance_type`: Specify EC2 instance configurations.
  - `db_name`, `db_username`, `db_password`: Configure the RDS database.
- **Why Modularize?**: By defining variables, you can easily adapt the infrastructure for different environments (e.g., development, staging, production) without hardcoding values.

---

### 3. **terraform.tfvars**

This file assigns specific values to the variables defined in `variables.tf`.

```hcl
aws_region           = "us-east-1"
vpc_cidr_block       = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_a_cidr = "10.0.2.0/24"
private_subnet_b_cidr = "10.0.3.0/24"
ami_id               = "ami-06c68f701d8090592"
instance_type        = "t2.micro"
key_name             = "my-ec2-key"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "application_db"
db_username          = "admin"
db_password          = "db*pass123"
```

#### **Explanation**:

- **Purpose**: Provides specific values for variables, ensuring flexibility across environments.
- **Why Modularize?**: By keeping variable values separate from the main configuration, you can easily switch between environments (e.g., dev, prod) without modifying the core Terraform files.

---

### 4. **vpc.tf**

This file creates the VPC, subnets, and internet gateway.

```hcl
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "us-east-1c"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}
```

#### **Explanation**:

- **Purpose**: Sets up the foundational networking components.
- **Key Resources**:
  - `aws_vpc`: Creates the VPC, which acts as the backbone for all other resources.
  - `aws_subnet`: Defines public and private subnets. Public subnets are used for resources that need internet access (e.g., ALB), while private subnets are used for internal resources (e.g., EC2 instances, RDS).
  - `aws_internet_gateway`: Provides internet access to resources in the public subnet.
- **Why Modularize?**: Separating networking components ensures clarity and makes it easier to manage and troubleshoot network-related issues.

---

### 5. **security_groups.tf**

This file defines security groups for the ALB, EC2 instances, and RDS database.

```hcl
resource "aws_security_group" "alb_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_security_group.id]
  }
}

resource "aws_security_group" "rds_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}
```

#### **Explanation**:

- **Purpose**: Controls inbound and outbound traffic for resources.
- **Key Security Groups**:
  - `alb_security_group`: Allows HTTP traffic from the internet.
  - `ec2_security_group`: Allows SSH access from the ALB and MySQL access from the RDS instance.
  - `rds_security_group`: Restricts MySQL access to within the VPC.
- **Why Modularize?**: Separating security groups improves readability and makes it easier to manage access controls.

---

### 6. **ec2_instances.tf**

This file provisions two EC2 instances in Private Subnet A.

```hcl
resource "aws_instance" "web_server1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = { Name = "WebServer1" }
}

resource "aws_instance" "web_server2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = { Name = "WebServer2" }
}
```

#### **Explanation**:

- **Purpose**: Deploys the application servers.
- **Key Attributes**:
  - `ami_id`: Specifies the Amazon Machine Image.
  - `instance_type`: Defines the compute capacity.
  - `subnet_id`: Places the instance in Private Subnet A.
- **Why Modularize?**: Separating EC2 instances allows you to scale or modify them independently without affecting other parts of the infrastructure.

---

### 7. **rds.tf**

This file creates the RDS MySQL database in Private Subnet B.

```hcl
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

resource "aws_db_instance" "rds_instance" {
  identifier            = "app-database"
  engine                = "mysql"
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  publicly_accessible   = false
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}
```

#### **Explanation**:

- **Purpose**: Sets up a managed MySQL database.
- **Key Attributes**:
  - `db_subnet_group`: Ensures high availability across subnets.
  - `publicly_accessible`: Prevents direct internet access.
- **Why Modularize?**: Separating the database configuration ensures that database-specific settings are isolated and easier to manage.

---

### 8. **alb.tf**

This file configures the ALB and its listener.

```hcl
resource "aws_lb" "application_load_balancer" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet_a.id
  ]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "Healthy"
    }
  }
}
```

#### **Explanation**:

- **Purpose**: Routes traffic to EC2 instances.
- **Key Attributes**:
  - `subnets`: Spans public and private subnets for high availability.
  - `listener`: Listens on port 80 and forwards traffic.
- **Why Modularize?**: Separating the ALB configuration ensures that load balancing logic is independent and easier to maintain.

---

### 9. **outputs.tf**

This file defines outputs for important information.

```hcl
output "load_balancer_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}
```

#### **Explanation**:

- **Purpose**: Provides access to critical resource details after deployment.
- **Why Modularize?**: Outputs make it easy to retrieve important information (e.g., DNS names, endpoints) without manually searching through the AWS console.

---

## Conclusion

By organizing the Terraform configuration into modular files, we ensure clarity, maintainability, and scalability. Each file plays a specific role in defining the infrastructure, from networking to compute and storage. With this setup, you can deploy a robust AWS environment that meets modern application requirements.
