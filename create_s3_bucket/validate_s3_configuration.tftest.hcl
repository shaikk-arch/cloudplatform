run "valid_s3_bucket_configuration" {

  command = plan

  assert {
    condition     = aws_s3_bucket_public_access_block.cloudplatform_bucket.block_public_acls == true
    error_message = "S3 bucket is not publicly accessible"
  }

}

