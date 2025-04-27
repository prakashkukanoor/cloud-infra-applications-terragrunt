locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  bucket_name         = local.common_vars.locals.bucket_name
  dynamodb_table_name = local.common_vars.locals.dynamodb_table_name
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = local.bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = local.dynamodb_table_name
  }
}