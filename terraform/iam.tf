resource "aws_iam_role" "fittrek_ec2" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "fittrek_s3" {
  name = "${var.project_name}-s3-policy"
  role = aws_iam_role.fittrek_ec2.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.fittrek.arn}/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "fittrek" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.fittrek_ec2.name
}