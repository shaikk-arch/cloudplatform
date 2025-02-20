
provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "cloudplatform_bucket" {
  bucket = "cloudplatform-s3-bucket"

  
  tags = {
    Name        = "My S3 Bucket"
    Environment = "Development"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudplatform_bucket" {
  bucket = aws_s3_bucket.cloudplatform_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


