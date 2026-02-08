#Include the parent terragrunt.hcl to inherit the remote_state block
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# include "sources" {
#   path   = find_in_parent_folders("sources.hcl")
#   expose = true
# }

include "regional" {
  path   = find_in_parent_folders("regional.hcl")
  expose = true
}

terraform {
  source = "git@github.com:prakashkukanoor/terraform-aws-vpc-subnets-routetable.git?ref=v1.0.7"
}


inputs = {
  region      = include.regional.locals.region
  team        = "devops"
  environment = "dev"

  # Variables to create networking
  vpc_cidr_ipv4     = "10.0.0.0/16"
  enable_ipv6       = true
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  application_public_subnets = [
    { "ipv4_cidr" : "10.0.0.0/24", "ipv6_index" : 0 },
    { "ipv4_cidr" : "10.0.1.0/24", "ipv6_index" : 1 },
    { "ipv4_cidr" : "10.0.2.0/24", "ipv6_index" : 2 }
  ]
  application_private_subnets = [
    { "ipv4_cidr" : "10.0.101.0/24", "ipv6_index" : 101 },
    { "ipv4_cidr" : "10.0.102.0/24", "ipv6_index" : 102 },
    { "ipv4_cidr" : "10.0.103.0/24", "ipv6_index" : 103 }
  ]
  database_private_subnets = [
    { "ipv4_cidr" : "10.0.201.0/24", "ipv6_index" : 201 },
    { "ipv4_cidr" : "10.0.202.0/24", "ipv6_index" : 202 },
    { "ipv4_cidr" : "10.0.203.0/24", "ipv6_index" : 203 }
  ]
  vpc_gateway_endpoints = {
    s3       = true
    dynamodb = true
  }
  vpc_interface_endpoints = {
    events = true
  }
}