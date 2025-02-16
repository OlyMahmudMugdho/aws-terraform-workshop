# Deploying Secure EC2 Instances with a Shared RDS Database**

This project involves deploying a scalable web application on AWS using Terraform. We will configure a Virtual Private Cloud (VPC), spin up EC2 instances, set up an RDS database, and distribute incoming traffic with an Application Load Balancer (ALB).

### Step 1: Configure the AWS Provider

Create a `provider.tf` file with the details of the AWS provider to enable connection with Terraform.

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}
```

### Step 2: Configure the VPC

Configure a VPC named `AppVPC` with a CIDR block of `10.0.0.0/16` and enable both DNS support and DNS hostnames.

**Note**: Ensure the VPC is correctly identified with the tag Name set to `AppVPC`.

Create a `vpc.tf` file:

```hcl
resource "aws_vpc" "AppVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AppVPC"
  }
}
```

Run `terraform init`, `plan`, and `apply` to create the VPC.

### Step 3: Configure Subnets

Create two subnets within `AppVPC`, one in `us-east-1a` with CIDR `10.0.1.0/24` and another in `us-east-1b` with CIDR `10.0.2.0/24`. Tag each subnet as `AppSubnet1` and `AppSubnet2`.

Append the following resource blocks to the `vpc.tf` file:

```hcl
resource "aws_subnet" "AppSubnet1" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "AppSubnet1"
  }
}

resource "aws_subnet" "AppSubnet2" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "AppSubnet2"
  }
}
```

Run the `plan` and `apply` commands to create the subnets.

### Step 4: Configure Security Group

Create a security group within `AppVPC` that allows web traffic on TCP ports `22`, `80`, `443`, and `3306` from anywhere, and allows external traffic to all IPs. Name the security group as `WebTrafficSG`.

Append the following to the `security_group.tf`:

```hcl
resource "aws_security_group" "WebTrafficSG" {
  vpc_id = aws_vpc.AppVPC.id
  name   = "WebTrafficSG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebTrafficSG"
  }
}
```

Run `terraform apply` to create the security group.

### Step 5: Create Network Interfaces

Create two network interfaces `nw-interface1` and `nw-interface2`, assigning them to `AppSubnet1` and `AppSubnet2`, respectively. Use the `WebTrafficSG` security group for both interfaces.

Append to the `network_interface.tf` file:

```hcl
resource "aws_network_interface" "nw-interface1" {
  subnet_id = aws_subnet.AppSubnet1.id
  security_groups = [aws_security_group.WebTrafficSG.id]
  tags = {
    Name = "nw-interface1"
  }  
}

resource "aws_network_interface" "nw-interface2" {
  subnet_id = aws_subnet.AppSubnet2.id
  security_groups = [aws_security_group.WebTrafficSG.id]
  tags = {
    Name = "nw-interface2"
  }  
}
```

Run `terraform apply` to create the network interfaces.

### Step 6: Set Up Internet Gateway and Route Table

Attach the VPC (`AppVPC`) to an Internet Gateway and create a route table `AppRouteTable`. Also, create a route in the route table for internet access.

Append the following to the `connections.tf` file:

```hcl
resource "aws_internet_gateway" "AppIGW" {
  vpc_id = aws_vpc.AppVPC.id

  tags = {
    Name = "AppInternetGateway"
  }
}

resource "aws_route_table" "AppRouteTable" {
  vpc_id = aws_vpc.AppVPC.id
  tags = {
    Name = "AppRouteTable"
  }
}

output "route_table_ID" {
  value = aws_route_table.AppRouteTable.id
}
```

### Step 7: Create a Route for Internet Access

Add a route to the `AppRouteTable` for internet access, setting the destination CIDR block to `0.0.0.0/0`.

Append to `connections.tf`:

```hcl
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.AppRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.AppIGW.id
}
```

Run `terraform apply`.

### Step 8: Associate Subnets with Route Table

Associate `AppSubnet1` and `AppSubnet2` with the `AppRouteTable`.

Append to `connections.tf`:

```hcl
resource "aws_route_table_association" "AppSubnet1_association" {
  subnet_id      = aws_subnet.AppSubnet1.id
  route_table_id = aws_route_table.AppRouteTable.id
}

resource "aws_route_table_association" "AppSubnet2_association" {
  subnet_id      = aws_subnet.AppSubnet2.id
  route_table_id = aws_route_table.AppRouteTable.id
}
```

### Step 9: Create Elastic IPs for EC2 Instances

Create two Elastic IPs (EIPs) and attach each to the respective network interface.

Append to `connections.tf`:

```hcl
resource "aws_eip" "public_ip1" {
  vpc = true
  network_interface = aws_network_interface.nw-interface1.id
}

resource "aws_eip" "public_ip2" {
  vpc = true
  network_interface = aws_network_interface.nw-interface2.id
}
```

### Step 10: Create EC2 Instances

Create two EC2 instances in `AppVPC`, one in each subnet. Use the AMI `ami-06c68f701d8090592` and the `t2.micro` instance type. 

Create the key-pair for the EC2 instances:

```bash
aws ec2 create-key-pair --key-name my-ec2-key --query 'KeyMaterial' --output text > /root/my-ec2-key.pem
chmod 600 /root/my-ec2-key.pem
```

Append the EC2 configuration to `ec2.tf`:

```hcl
resource "aws_instance" "WebServer1" {
  ami             = "ami-06c68f701d8090592"
  instance_type   = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nw-interface1.id
    device_index = 0
  }

  key_name = "my-ec2-key"

  tags = {
    Name = "WebServer1"
  }
}

resource "aws_instance" "WebServer2" {
  ami             = "ami-06c68f701d8090592"
  instance_type   = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nw-interface2.id
    device_index = 0
  }

  key_name = "my-ec2-key"

  tags = {
    Name = "WebServer2"
  }
}
```

### Step 11: Add Output for Instance IDs

Add output blocks to `outputs.tf` for the EC2 instance IDs:

```hcl
output "instance1_id" {
  value = aws_instance.WebServer1.id
}

output "instance2_id" {
  value = aws_instance.WebServer2.id
}
```

### Step 12: Set Up the RDS Database

Create an RDS instance in `AppVPC` with the following configuration:

```hcl
resource "aws_db_instance" "

AppDatabase" {
  allocated_storage = 20
  db_instance_class = "db.t3.micro"
  engine            = "mysql"
  engine_version    = "8.0"
  username          = "admin"
  password          = "password123"
  db_name           = "appdb"
  vpc_security_group_ids = [aws_security_group.WebTrafficSG.id]
  db_subnet_group_name  = aws_db_subnet_group.AppDBSubnetGroup.name

  tags = {
    Name = "AppDatabase"
  }
}
```

### Step 13: Apply Terraform

After all resources are configured, run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

This will deploy the entire infrastructure.


## Connecting to the infrastructure

To connect to the RDS database from one of your EC2 instances and run SQL queries, follow these steps:

### Step 1: SSH into the EC2 Instance
Grab the public IPv4 address of one of your EC2 instances (WebServer1 or WebServer2) from the AWS Management Console.

In your terminal, run the following command to SSH into the EC2 instance:

```bash
ssh -i my-ec2-key.pem ec2-user@<public_IP>
```

Replace `<public_IP>` with the actual public IPv4 address of the EC2 instance.

When prompted with:

```
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes` to continue.

### Step 2: Install MySQL Client
Since the EC2 instance doesn’t have MySQL pre-installed, you need to install it. Run the following commands to install the MySQL client:

```bash
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
```

Then install the MySQL community release:

```bash
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
```

Next, import the MySQL GPG key:

```bash
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
```

Finally, install the MySQL community client:

```bash
sudo dnf install mysql-community-client -y
```

### Step 3: Connect to the RDS Database
Now that MySQL is installed, you can connect to your RDS instance. Run the following command:

```bash
mysql -h <DB_endpoint> -P 3306 -u admin -p
```

Replace `<DB_endpoint>` with the actual endpoint of your RDS instance. You can find the RDS endpoint from the AWS Management Console under your RDS instance details.

When prompted for the password, enter the password you created for your RDS instance via Terraform, which is `db*pass123`.

### Step 4: Query the Database
Once logged into MySQL, run the following query to list the databases:

```sql
SHOW DATABASES;
```

You should see a list of databases. One of them will be `appdatabase`—the database we created through Terraform.

### Step 5: Create Tables and Schema
Now, you can create tables and the schema for your application. For example, to create a table in the `appdatabase`, you could run:

```sql
USE appdatabase;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
```

### Step 6: Access the Database from Another EC2 Instance
To demonstrate that the RDS database is shared and accessible from both EC2 instances, log in to the other EC2 instance (WebServer2 or WebServer1).

SSH into the second instance:

```bash
ssh -i my-ec2-key.pem ec2-user@<public_IP_2>
```

Then, use the same MySQL command to connect to the RDS database:

```bash
mysql -h <DB_endpoint> -P 3306 -u admin -p
```

Enter the password (`db*pass123`), and you should be able to query the `appdatabase` database and see the table(s) you created. For example:

```sql
USE appdatabase;

SELECT * FROM users;
```

This demonstrates that the RDS database is accessible from both EC2 instances, confirming that it functions as a shared database instance.

---

### Recap

- We have connected from one EC2 instance to the RDS database.
- Installed MySQL client on the EC2 instance.
- Verified the shared access to the RDS database by querying it from both EC2 instances.
