#Include the parent terragrunt.hcl to inherit the remote_state block
include "root" {
  path = find_in_parent_folders()
}

# Define specific values for this child configuration
locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  bucket_name         = local.parent_config.locals.bucket_name
  dynamodb_table_name = local.parent_config.locals.dynamodb_table_name
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = var.region
  }
  provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
  }
EOF
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-s3-module.git"
}

inputs = {
  region               = "us-east-1"
  team                 = "devops"
  environment          = "PROD"
  bucket_names = ["product-001"]
  path_to_json_file = "/Users/prakashkukanoor/Documents/GIT/cloud-infra-applications-terragrunt/aws/workload-account-123456789/project-name-xyz/networking/environments/production/s3_policy.json.tpl"
}