#Include the parent terragrunt.hcl to inherit the remote_state block
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-s3-module.git"
}

# Define specific values for this child configuration
locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  bucket_name         = local.parent_config.locals.bucket_name
  dynamodb_table_name = local.parent_config.locals.dynamodb_table_name
  current_dir = get_terragrunt_dir()
}

inputs = {
  region               = "us-east-1"
  team                 = "devops"
  environment          = "PROD"
  
  applications = {
    functional_domain_01 = {
      buckets = ["product-001"]
      policy_json_tpl_file_path = "${get_terragrunt_dir()}/s3_policy.json.tpl"
    }
    functional_domain_02 = {
      buckets = ["product-002"]
      policy_json_tpl_file_path = "${get_terragrunt_dir()}/s3_policy.json.tpl"
    }

  }
  
}