#These are the only value that need to be changed on implementation
region                   = "eu-west-2"

vpc_cidr                 = "10.0.0.0/16"
public_subnet_1          = "10.0.16.0/20"
public_subnet_2          = "10.0.32.0/20"
private_subnet_1         = "10.0.80.0/20"
private_subnet_2         = "10.0.112.0/20"

availibilty_zone_1       = "eu-west-2a"
availibilty_zone_2       = "eu-west-2b"

container_port           = 80

shared_config_files      = "" # Replace with path
shared_credentials_files = "" # Replace with path
credential_profile       = "" # Replace with what you named your profilea

default_tags = {
  Department  = "gc3"
  Project     = "misp"
  Environment = "dev"
  Terraform   = "true"
}

