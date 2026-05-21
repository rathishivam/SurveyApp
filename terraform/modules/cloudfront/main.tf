# CloudFront module for serving the UI from S3
# Creates an OAI and distribution for the given S3 bucket.

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${var.name}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = var.default_root_object

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "${var.name}-s3-origin"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.this.id}"
    }
  }

  default_cache_behavior {
    target_origin_id       = "${var.name}-s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          CanonicalUser = aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}
