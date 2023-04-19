locals {
  ec2_secret_data = data.vault_generic_secret.ec2_data.data
  kms_secret_data = data.vault_generic_secret.kms_data.data
}