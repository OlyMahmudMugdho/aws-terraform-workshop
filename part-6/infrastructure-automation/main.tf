provider "github" {
  token = var.github_token
}

resource "github_repository" "terraform-infra-repo" {
  name        = var.repository_name
  description = var.repository_description
  visibility  = var.repository_visibility
  has_issues  = var.repository_has_issues
  has_wiki    = var.repository_has_wiki
}