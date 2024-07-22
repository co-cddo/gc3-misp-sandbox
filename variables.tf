variable "default_tags" {
    type = map
    description = "Set of default tags"
}

variable "tfstate_bucket" {
    type  = string
    value = "gccc-misp-tfstate"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  type        = string
  default     = "gccc-misp-tfstate-table"
}