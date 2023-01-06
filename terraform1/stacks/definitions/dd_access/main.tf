terraform {
  required_version = "> 1.0.0"

  backend "s3" {
    workspace_key_prefix = "workspaces"
  }

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.19.1"
    }
  }
}
