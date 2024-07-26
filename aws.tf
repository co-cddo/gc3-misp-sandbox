provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

data "terraform_remote_state" "stetefiles-statefile" {
  backend = "s3"
  config = {
    bucket         = "gccc-misp-${var.environment}-tfstate"
    key            = "aws_dynamodb_table.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
  }
}

data "terraform_remote_state" "identity-statefile" {
  backend = "s3"
  config = {
    bucket         = "gccc-misp-${var.environment}-tfstate"
    key            = "aws_identity.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
  }
}

#  
# This module was going to be called to create the AWS IAM Identity Provider to be used by githiub for builds 
# but as I do not have the priv to create theidentity provider or the required roles I can't use it and will have 
# to have it by someone else.check 
# I am keeping it as it may be useful.
#
#module identity_provider {
#  source = "./identity_provider"
#}

module misp-ecr {
  source = "./modules/misp-ecr"
}

module misp-fargate {
  source = "./modules/misp-fargate"
  cluster_name = "misp"
  service_name = "misp"
  region = var.region
  vpc_cidr = "10.0.0.0/16"
  numb_azs = 3
  container_name = "misp"
  container_port = "80"
  default_tags = var.default_tags
}

#module misp-container {
#  ecr_url = module.misp-ecr.repository_url
#  source = "./modules/misp-container"
#}
