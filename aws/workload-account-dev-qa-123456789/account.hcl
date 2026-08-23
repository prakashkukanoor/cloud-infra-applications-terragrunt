locals {
  tf_admin_arn        = "arn:aws:iam::843976229340:user/tf-admin"
  aws_account_number  = split("::", regex("::[[:digit:]]+", local.tf_admin_arn))[1]
}