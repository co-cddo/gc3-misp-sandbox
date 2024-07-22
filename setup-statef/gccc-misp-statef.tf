terraform {
  backend "s3" {
    bucket = "gccc-misp-tfstate"
    key    = "aws_dynamodb_table.hash_key"
  }
}


#---------------------------------------------------------------------------------------------------
# DynamoDB
#---------------------------------------------------------------------------------------------------
locals {
  # The table must have a primary key named LockID.
  # See below for more detail.
  # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  lock_key_id = "LockID"
}

resource "aws_dynamodb_table" "lock" {
  name                        = var.dynamodb_table_name
  billing_mode                = var.dynamodb_table_billing_mode
  hash_key                    = local.lock_key_id
  deletion_protection_enabled = var.dynamodb_deletion_protection_enabled
  attribute {
    name = local.lock_key_id
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
  tags = var.default_tags
}


#---------------------------------------------------------------------------------------------------
# Bucket Policies
#---------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "state_force_ssl" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

#---------------------------------------------------------------------------------------------------
# Bucket
#---------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "tfstate_force_ssl" {
  bucket     = aws_s3_bucket.tfstate.id
  policy     = data.aws_iam_policy_document.state_force_ssl.json
  depends_on = [aws_s3_bucket_public_access_block.state]
}
resource "aws_s3_bucket" "tfstate" {
  bucket        = var.tfstate_bucket
  force_destroy = var.s3_bucket_force_destroy
  tags          = var.tags
}
resource "aws_s3_bucket_ownership_controls" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "tfstate" {
  depends_on = [aws_s3_bucket_ownership_controls.tfstate]
  bucket     = aws_s3_bucket.tfstate.id
  acl        = "private"
}
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
