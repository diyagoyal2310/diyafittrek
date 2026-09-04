output "ec2_public_ip" {
  description = "Public IP address of FitTrek EC2"
  value       = aws_instance.fittrek.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of FitTrek EC2"
  value       = aws_instance.fittrek.public_dns
}

output "s3_bucket_name" {
  description = "FitTrek S3 bucket name"
  value       = aws_s3_bucket.fittrek.bucket
}

output "cloudfront_domain_name" {
  description = "FitTrek CloudFront domain"
  value       = aws_cloudfront_distribution.fittrek.domain_name
}