run "valid_s3_bucket_existence" {

  command = plan

  assert {
    condition     = aws_s3_bucket.cloudplatform_bucket.bucket == "cloudplatform-s3-bucket"
    error_message = "S3 bucket name did not match expected"
  }

}

