resource "aws_s3_bucket" "fittrek" {
  bucket_prefix = "${var.project_name}-"

  tags = {
    Name = "${var.project_name}-storage"
  }
}

resource "aws_s3_bucket_public_access_block" "fittrek" {
  bucket = aws_s3_bucket.fittrek.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "fittrek" {
  bucket = aws_s3_bucket.fittrek.id

  versioning_configuration {
    status = "Enabled"
  }
}