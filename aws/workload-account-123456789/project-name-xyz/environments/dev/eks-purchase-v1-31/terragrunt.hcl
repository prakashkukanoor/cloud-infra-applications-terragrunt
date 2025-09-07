#Include the parent terragrunt.hcl to inherit the remote_state block
include "sources" {
  path   = find_in_parent_folders("sources.hcl")
  expose = true
}

dependency "networking" {
  config_path = "${dirname(find_in_parent_folders("sources.hcl"))}/global/networking"
}

terraform {
  source = include.sources.locals.tf_module_repos.eks
}

# Define specific values for this child configuration
locals {
  sources             = read_terragrunt_config(find_in_parent_folders("sources.hcl"))
  parent_config       = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  bucket_name         = local.parent_config.locals.bucket_name
  dynamodb_table_name = local.parent_config.locals.dynamodb_table_name
  current_dir         = get_terragrunt_dir()
  cluster_name        = split("eks-", local.current_dir)[1]
  arn                 = "arn:aws:iam::851725238641:user/admin-terraform"
}

inputs = {
  region      = "us-east-1"
  team        = "devops"
  environment = "dev"

  cluster_name               = local.cluster_name
  worker_node_instance_types = ["t2.micro"]
  node_group_desired_size    = 3
  node_group_min_size        = 3
  node_group_max_size        = 4
  capacity_type              = "ON_DEMAND"
  private_subnets            = dependency.networking.outputs.application_private_subnet_ids

  # instance_type = "t2.micro"
  # number_of_ec2 = 2
  # filter_name = "al2023-ami-2023.*-x86_64"
  applications = {
    functional_domain_01 = {
      buckets                        = ["product-105"]
      dynamodb_tables                = ["dynamo-db-105"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
    }
    functional_domain_02 = {
      buckets                        = ["product-103"]
      dynamodb_tables                = ["dynamo-db-103"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
    }

  }

}