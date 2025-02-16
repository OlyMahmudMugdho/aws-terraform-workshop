#!/bin/bash
aws ec2 create-key-pair --key-name my-ec2-key --query 'KeyMaterial' --output text > /root/my-ec2-key.pem
chmod 600 /root/my-ec2-key.pem