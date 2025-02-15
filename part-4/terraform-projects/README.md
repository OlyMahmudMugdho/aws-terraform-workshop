# Managing Terraform State in AWS
This guide explains how to manage Terraform state using AWS S3 for storage and DynamoDB for state locking.

## Prerequisites
 AWS CLI configured with appropriate credentials
- Terraform installed (v1.0.0 or later)
- Appropriate AWS permissions for S3 and DynamoDB


## Initial Setup

### 1. Create S3 Bucket for State Storage


```bash
aws s3 mb s3://my-terraform-state-bucket-olymahmud --region us-east-1
```

### Verify bucket creation

``` bash
aws s3 ls | grep my-terraform-state-bucket-olymahmud
```

### 2. Init and apply the tf config

```bash
terraform init
terraform apply
```

### 3. Verify if migration was successful

```bash
aws s3 ls s3://my-terraform-state-bucket-olymahmud/terraform/state
```

### 4. Verify DynamoDB Lock Table


``` bash
aws dynamodb list-tables | grep my-lock-table
```

## State Management Operations

### List Resources in State

Save resource list to file:

``` bash
terraform state list > /root/resrc-list.txt
```

### View Resource Details

**View EC2 instance details**

``` bash
terraform state show aws_instance.ec2-1
```

### Remove The old Resource from State

```bash
terraform state rm aws_instance.ec2-1
```

we have created another ec2-instance using aws cli
we want to manage the association of the resource ec2-instance using terraform
so we update the code

### then re-initialize Terraform

```bash
terraform init -upgrade
```

### run the import command to import the resource

```bash
terraform import <resource_name_eg_aws_instance.ec2-backup> <instance_id>
```

### run the mv command to rename the resource in the state

```bash
terraform state mv aws_instance.ec2-2 aws_instance.ec2-backup
```


### Verify and apply the changes:

```bash
terraform plan
terraform apply
```

### see the condition of Terraform state at present

```bash
aws dynamodb scan --table-name my-lock-table
```

### remove the lock 
A manual lock on the Terraform state locks the state, preventing further operations.

The only way to resume operations is to unlock the state. However, there are two ways to do this - either delete the lock entry from the table or use the unlock command.

The following AWS CLI command unlocks the state by deleting the lock entry from the table:

```bash
aws dynamodb delete-item --table-name my-lock-table --key '{"LockID": {"S": "<lockID>"}}'
```

The following Terraform command, when executed, will unlock the state and allow to apply the Terraform lifecycle:

```bash
terraform force-unlock <lockID>
```