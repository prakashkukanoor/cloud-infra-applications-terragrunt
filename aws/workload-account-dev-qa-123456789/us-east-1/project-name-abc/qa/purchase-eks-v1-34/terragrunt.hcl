#Include the parent terragrunt.hcl to inherit the remo
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "regional" {
  path   = find_in_parent_folders("regional.hcl")
  expose = true
}

# include "sources" {
#   path   = find_in_parent_folders("sources.hcl")
#   expose = true
# }

locals {
  cluster_name       = "purchase"
  aws_account_number = "703110344418"
  arn                = "arn:aws:iam::703110344418:user/tf-admin"
  team               = "devops"
  environment        = "qa"
}

dependency "networking" {
  config_path = "${dirname(find_in_parent_folders("root.hcl"))}/${include.regional.locals.region}/shared/environment/${local.environment}/networking"
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-module-root.git"
}

inputs = {
  # ==============================================================================
  # DESCRIPTION: Common Variables used in most or all of the modules
  # ENV / REGION: DEV / us-east-1
  # ==============================================================================
  region      = include.regional.locals.region
  team        = local.team
  environment = local.environment

  # ==============================================================================
  # MODULE COMPONENT: EKS Cluster module configurations
  # DESCRIPTION: Cluster provisioned in private subnets
  # ==============================================================================
  cluster_name                     = local.cluster_name
  eks_version                      = "1.33"
  eks_endpoint_private_access      = false
  eks_endpoint_public_access       = true
  eks_worker_node_desired_capacity = 3
  eks_worker_node_min_size         = 3
  eks_worker_node_max_size         = 6
  # capacity_type              = "ON_DEMAND"
  application_private_subnet_ids = dependency.networking.outputs.application_private_subnet_ids
  db_subnet_ids                  = dependency.networking.outputs.database_private_subnet_ids
  db_subnets_ipv4_cidr           = dependency.networking.outputs.database_private_subnets_ipv4_cidr_block
  vpc_id                         = dependency.networking.outputs.vpc_id
  instance_type                  = "t3.medium"
  ami_type                       = "amazon-linux-2023/x86_64/standard"
  aws_account_number             = local.aws_account_number
  eks_iam_user_access = {
    admin  = ["cloud_user"]
    editor = []
    viewer = []
  }

  # ==============================================================================
  # MODULE COMPONENT: Load Balancer - Application or Network
  # DESCRIPTION: Support for both public or private load balancer
  # ==============================================================================
  application_public_subnet_ids = dependency.networking.outputs.application_public_subnet_ids
  load_balancer_type            = "network" #"application/network"
  load_balancing_algorithm_type = "round_robin" # not applicable for NLB
  lb_targetGroup_port           = 31234
  lb_healthCheck_port           = 31903
  is_lb_internal                = false
  target_type                   = "instance"

  # ==============================================================================
  # MODULE COMPONENT: RDS, S3 etc.
  # DESCRIPTION: Application teams can manage required resource for specific namespace.
  # ==============================================================================

  applications = {
    product = {
      services                       = ["product-01"]
      buckets                        = ["product-106"]
      dynamodb_tables                = ["dynamo-db-106"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
      postgress = {
        engine              = "postgres"
        engine_version      = "14.20"
        instance_class      = "db.t3.micro"
        username            = "adminuser"
        password            = "Admin12345!"
        db_family           = "postgres14"
        skip_final_snapshot = true
      }
    }
    purchase = {
      services                       = ["purchase-01"]
      buckets                        = ["purchase-105"]
      dynamodb_tables                = ["dynamo-db-105"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
      postgress = {
        engine              = "postgres"
        engine_version      = "14.20"
        instance_class      = "db.t3.micro"
        username            = "adminuser"
        password            = "Admin12345!"
        db_family           = "postgres14"
        skip_final_snapshot = true
      }
    }

  }

}