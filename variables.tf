variable "region" {
  description = "Main region for all resources"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the main VPC"
}

variable "public_subnet_1" {
  type        = string
  description = "CIDR block for public subnet 1"
}

variable "public_subnet_2" {
  type        = string
  description = "CIDR block for public subnet 2"
}

variable "private_subnet_1" {
  type        = string
  description = "CIDR block for private subnet 1"
}

variable "private_subnet_2" {
  type        = string
  description = "CIDR block for private subnet 2"
}

variable "availibilty_zone_1" {
  type        = string
  description = "First availibility zone"
}

variable "availibilty_zone_2" {
  type        = string
  description = "First availibility zone"
}

variable "default_tags" {
  type = map(any)
  default = {
    Application = "phhmisp"
    Environment = "dev"
  }
}

variable "container_port" {
  description = "Port that needs to be exposed for the application"
}

variable "shared_config_files" {
  description = "Path of your shared config file in .aws folder"
}

variable "shared_credentials_files" {
  description = "Path of your shared credentials file in .aws folder"
}

variable "credential_profile" {
  description = "Profile name in your credentials file"
  type        = string
}

