#!/bin/bash
ssh-keygen -t rsa -b 4096 -f my-key.pem
aws ec2 import-key-pair --key-name "my-key" --public-key-material fileb://my-key.pem.pub