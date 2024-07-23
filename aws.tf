provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
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
