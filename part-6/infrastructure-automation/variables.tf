variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username"
  type        = string
  default     = "OlyMahmudMugdho"
}

variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  default     = "terraform-infra"
}

variable "repository_description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = "Infrastructure repository managed by Terraform"
}

variable "repository_visibility" {
  description = "Visibility of the GitHub repository"
  type        = string
  default     = "public"
}

variable "repository_has_issues" {
  description = "Enable issues for the repository"
  type        = bool
  default     = true
}

variable "repository_has_wiki" {
  description = "Enable wiki for the repository"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
}
