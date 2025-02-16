resource "aws_codepipeline" "terraform-web-app-pipeline" {
  name     = "terraform-web-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.bucket_name 
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_username              
        Repo       = var.repository_name               # Repository name
        Branch     = "main"                          # Branch name
        OAuthToken = var.github_token         
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ElasticBeanstalk"
      version          = "1"
      input_artifacts  = ["source_output"]

      configuration = {
        ApplicationName = "terraform-web-app"
        EnvironmentName = "devm"
      }
    }
  }
}