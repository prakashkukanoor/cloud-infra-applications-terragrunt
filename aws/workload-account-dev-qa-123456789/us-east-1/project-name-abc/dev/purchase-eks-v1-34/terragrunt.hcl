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
  arn                 = "arn:aws:iam::381492137270:user/tf-admin"
  team                = "devops"
  environment         = "dev"
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
  # worker_node_instance_types = ["t2.micro"]
  node_group_desired_size    = 3
  node_group_min_size        = 3
  node_group_max_size        = 4
  # capacity_type              = "ON_DEMAND"
  application_private_subnet_ids            = dependency.networking.outputs.application_private_subnet_ids
  db_subnet_ids = dependency.networking.outputs.database_private_subnet_ids

  instance_type = "t2.micro"
  filter_name = "amazon-eks-node-al2023-x86_64-standard-1.31-*"
  # number_of_ec2 = 2

  applications = {
    product = {
      buckets                        = ["product-105"]
      dynamodb_tables                = ["dynamo-db-105"]
      # postgres                        = ["product-105"]
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
          db_names = ["product105"]
          identifier = "db-product-rds-105"
        }
    }
    purchase = {
      buckets                        = ["purchase-103"]
      dynamodb_tables                = ["dynamo-db-103"]
      # postgres                        = ["product-103"]
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
          db_names = ["purchase103"]
          identifier = "dbpurchase-rds-103"
        }
    }

  }

}