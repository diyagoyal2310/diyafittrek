resource "aws_cloudfront_origin_access_control" "fittrek" {
  name                              = "${var.project_name}-oac"
  description                       = "CloudFront access to FitTrek S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "fittrek" {
  enabled = true

  origin {
    domain_name              = aws_s3_bucket.fittrek.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.fittrek.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.fittrek.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.fittrek.id}"

    viewer_protocol_policy = "redirect-to-https"

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

  tags = {
    Name = "${var.project_name}-cloudfront"
  }
}