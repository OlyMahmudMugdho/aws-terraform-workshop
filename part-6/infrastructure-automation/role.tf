resource "aws_iam_role" "codepipeline_role" {
  name = "iam_role_for_codepipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {

  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "codecommit:*",
          "codebuild:*",
          "elasticbeanstalk:*",
          "cloudformation:*",
          "autoscaling:*",
          "ec2:*",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}