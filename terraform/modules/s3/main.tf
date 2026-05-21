# S3 module for UI hosting
# Creates an S3 bucket to store the static UI files.

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

#   acl            = "private"
  force_destroy  = var.force_destroy
  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
