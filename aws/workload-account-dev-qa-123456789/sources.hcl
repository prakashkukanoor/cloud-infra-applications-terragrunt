locals {
  tf_modules = {
    root_module = "git@github.com:prakashkukanoor/terraform-aws-module-root.git"
    network_module = "git@github.com:prakashkukanoor/terraform-aws-vpc-subnets-routetable.git?ref=v1.0.7"
  }
}