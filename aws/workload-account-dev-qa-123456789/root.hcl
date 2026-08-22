locals {
  bucket_name         = "infra-applications-terraform-satefile-22"
  dynamodb_table_name = "infra-applications-terraform-state-lock-22"
  aws_account_number  = "891572012759"
  tf_admin_arn        = "arn:aws:iam::891572012759:user/tf-admin"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = local.bucket_name
    key            = "account-id-${local.aws_account_number}/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = local.dynamodb_table_name
  }
}