variable "default_tags" {
    type = map
    description = "Set of default tags"
}

variable "region" {
    type    = string
    default = "eu-west-2"
}

variable "tfstate_bucket" {
    type    = string
    default = "gccc-misp-tfstate"
}

variable "s3_bucket_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  type        = string
  default     = "gccc-misp-tfstate-table"
}

variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_deletion_protection_enabled" {
  description = "Whether or not to enable deletion protection on the DynamoDB table"
  type        = bool
  default     = true
}
