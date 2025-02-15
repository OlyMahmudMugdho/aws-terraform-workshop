# Working with Terraform Workspaces

Terraform workspaces allow you to manage multiple states for the same configuration. This is particularly useful when you need to maintain different environments (like development, staging, and production) using the same Terraform code.

## Creating a New Workspace

To create a new workspace, use the following command:

```bash
terraform workspace new test-workspace
```

## Listing Available Workspaces

You can view all available workspaces with:

```bash
terraform workspace list
```

The active workspace will be marked with an asterisk (*).

## Switching Between Workspaces

To switch to a different workspace, use the select command:

```bash
terraform workspace select default
```

This command will switch back to the default workspace. Replace `default` with any other workspace name to switch to that environment.

> **Note**: Each workspace maintains its own state file, allowing you to manage different environments independently.
