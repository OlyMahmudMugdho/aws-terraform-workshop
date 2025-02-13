#!/bin/bash
aws secretsmanager create-secret --name my-database-password --secret-string "my-secret-password"