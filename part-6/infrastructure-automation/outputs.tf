output "repository_clone_url_ssh" {
  description = "SSH clone URL of the created repository"
  value       = github_repository.terraform-infra-repo.ssh_clone_url
}

output "repository_html_url" {
  description = "HTML URL of the created repository"
  value       = github_repository.terraform-infra-repo.html_url
}

output "repository_git_clone_url" {
  description = "Git clone URL of the created repository"
  value       = github_repository.terraform-infra-repo.git_clone_url
}