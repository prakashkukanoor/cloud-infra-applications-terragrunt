locals {
  bucket_name         = "infra-applications-terraform-satefile-25"
  dynamodb_table_name = "infra-applications-terraform-state-lock-25"
  account  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = local.bucket_name
    key            = "account-id-${local.account.locals.aws_account_number}/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = local.dynamodb_table_name
  }
}