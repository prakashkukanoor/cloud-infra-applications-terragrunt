#Include the parent terragrunt.hcl to inherit the remote_state block
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-module-root.git"
}

# Define specific values for this child configuration
locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  bucket_name         = local.parent_config.locals.bucket_name
  dynamodb_table_name = local.parent_config.locals.dynamodb_table_name
  current_dir = get_terragrunt_dir()
  arn = "arn:aws:iam::637423456632:user/cloud_user"
}

inputs = {
  region               = "us-east-1"
  team                 = "devops"
  environment          = "PROD"

  # Variables to create networking
  vpc_cidr_ipv4 = "10.0.0.0/16"
  enable_ipv6 = true
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  application_public_subnets = [
    {"ipv4_cidr": "10.0.0.0/24", "ipv6_index": 0},
    {"ipv4_cidr": "10.0.1.0/24", "ipv6_index": 1},
    {"ipv4_cidr": "10.0.2.0/24", "ipv6_index": 2}
  ]
  application_private_subnets = [
    {"ipv4_cidr": "10.0.101.0/24", "ipv6_index": 101},
    {"ipv4_cidr": "10.0.102.0/24", "ipv6_index": 102},
    {"ipv4_cidr": "10.0.103.0/24", "ipv6_index": 103}
  ]
  database_private_subnets = [
    {"ipv4_cidr": "10.0.201.0/24", "ipv6_index": 201},
    {"ipv4_cidr": "10.0.202.0/24", "ipv6_index": 202},
    {"ipv4_cidr": "10.0.203.0/24", "ipv6_index": 203}
  ]
  vpc_gateway_endpoints = {
    s3        = true
    dynamodb  = true
  }
  vpc_interface_endpoints = {
    events        = true
  }
  
  instance_type = "t2.micro"
  number_of_ec2 = 2
  filter_name = "al2023-ami-2023.*-x86_64"
  applications = {
    functional_domain_01 = {
      buckets = ["product-001"]
      dynamodb_tables = ["dynamo-db-001"]
      arn = local.arn
      s3_policy_json_tpl_path = "${get_terragrunt_dir()}/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/dynamodb_policy.json.tpl"
    }
    functional_domain_02 = {
      buckets = ["product-002"]
      dynamodb_tables = ["dynamo-db-002"]
      arn = local.arn
      s3_policy_json_tpl_path = "${get_terragrunt_dir()}/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/dynamodb_policy.json.tpl"
    }

  }
  
}