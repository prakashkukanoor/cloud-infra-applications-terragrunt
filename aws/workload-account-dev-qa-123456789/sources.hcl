locals {
  tf_module_repos = {
    networking = "git@github.com:prakashkukanoor/terraform-aws-vpc-subnets-routetable.git?ref=v1.0.5"
    s3         = "git@github.com:prakashkukanoor/terraform-aws-s3-module.git?ref=v1.0.1"
    dynamodb   = "git@github.com:prakashkukanoor/terraform-aws-dynamodb-module.git?ref=v1.0.1"
    eks        = "git@github.com:prakashkukanoor/terraform-aws-eks-module.git?ref=v1.0.0"
  }
}