#!/usr/bin/env bash
# aws ecr create-repository --region "$REGION" --repository-name bot
cd terraform/repo
terraform init
terraform apply --auto-approve