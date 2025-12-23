locals {
  bucket_name         = "infra-applications-terraform-satefile-19"
  dynamodb_table_name = "infra-applications-terraform-state-lock-19"
  account_id         = "123456789"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = local.bucket_name
    key            = "account-id-${local.account_id}/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = local.dynamodb_table_name
  }
}