provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

#module identity_provider {
#  source = "./identity_provider"
#}
