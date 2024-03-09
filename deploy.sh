#!/bin/bash
# configure aws credentials
# Prompt the user for AWS access key ID
read -p "Enter your AWS access key ID: " aws_access_key_id

# Prompt the user for AWS secret access key
read -p "Enter your AWS secret access key: " aws_secret_access_key

# Write the AWS credentials to the ~/.aws/credentials file
cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
EOF

# Provide feedback to the user
echo "AWS credentials have been saved to ~/.aws/credentials."

# Initialize Terraform
terraform init
# Validate the code
terraform validate && terraform plan -out=plan.out 
# Apply Terraform configuration
terraform apply --auto-approve "plan.out"

