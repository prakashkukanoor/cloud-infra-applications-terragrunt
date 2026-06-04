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
  cluster_name        = "purchase"
  arn                 = "arn:aws:iam::974197459140:user/tf-admin"
  console_user        = "arn:aws:iam::974197459140:user/cloud_user"
  team                = "devops"
  environment         = "qa"
}

dependency "networking" {
  config_path = "${dirname(find_in_parent_folders("root.hcl"))}/${include.regional.locals.region}/shared/environment/${local.environment}/networking"
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-module-root.git"
}

inputs = {
  region      = include.regional.locals.region
  team        = local.team
  environment = local.environment

  cluster_name               = local.cluster_name
  eks_version = "1.33"
  eks_endpoint_private_access = false
  eks_endpoint_public_access = true
  eks_worker_node_desired_capacity    = 2
  eks_worker_node_min_size        = 1
  eks_worker_node_max_size        = 3
  # capacity_type              = "ON_DEMAND"
  application_private_subnet_ids            = dependency.networking.outputs.application_private_subnet_ids
  db_subnet_ids = dependency.networking.outputs.database_private_subnet_ids
  db_subnets_ipv4_cidr = dependency.networking.outputs.database_private_subnets_ipv4_cidr_block
  vpc_id = dependency.networking.outputs.vpc_id

  instance_type = "t2.micro"
  ami_type = "amazon-linux-2023/x86_64/standard"
  eks_iam_access = [
    {
      user_arn = "${local.arn}"
      role   = "admin"
    },
    {
      user_arn = "${local.console_user}"
      role   = "admin"
    }
  ]

  applications = {
    product = {
      services = ["product-01"]
      buckets                        = ["product-106"]
      dynamodb_tables                = ["dynamo-db-106"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
      postgress = {
          engine               = "postgres"
          engine_version       = "14.20"
          instance_class       = "db.t3.micro"
          username             = "adminuser"
          password             = "Admin12345!"
          db_family            = "postgres14"
          skip_final_snapshot  = true
        }
    }
    purchase = {
      services = ["purchase-01"]
      buckets                        = ["purchase-105"]
      dynamodb_tables                = ["dynamo-db-105"]
      arn                            = local.arn
      s3_policy_json_tpl_path        = "${get_terragrunt_dir()}/policy/s3_policy.json.tpl"
      dynamo_db_policy_json_tpl_path = "${get_terragrunt_dir()}/policy/dynamodb_policy.json.tpl"
      postgress = {
          engine               = "postgres"
          engine_version       = "14.20"
          instance_class       = "db.t3.micro"
          username             = "adminuser"
          password             = "Admin12345!"
          db_family            = "postgres14"
          skip_final_snapshot  = true
        }
    }

  }

}