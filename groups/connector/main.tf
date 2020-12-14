# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.3, < 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.0.0"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = ">= 20.12"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

provider "netapp-cloudmanager" {
  refresh_token = local.netapp_account_data["refresh-token"]
<<<<<<< HEAD:groups/connector/main.tf
}
=======
}
>>>>>>> d0ff6d0... CVO code completed with per environment vars and conditionals based on HA/NonHA setup:groups/cvo/main.tf
