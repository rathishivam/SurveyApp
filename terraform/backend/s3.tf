resource "aws_s3_bucket" "survey-s3" {
  bucket = "survey-terraform-state"

  tags = {
    Name        = "survey-terraform-state"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "survey-s3-public-access" {
  bucket = aws_s3_bucket.survey-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}