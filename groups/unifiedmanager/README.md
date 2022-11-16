# XML Infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_unified_manager_ec2_security_group"></a> [unified\_manager\_ec2\_security\_group](#module\_unified\_manager\_ec2\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |
| <a name="module_unified_manager_profile"></a> [unified\_manager\_profile](#module\_unified\_manager\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40 |  |
| <a name="module_aiqum_backup_bucket"></a> [unified\_manager\_ec2\_security\_group](#module\aiqum_backup_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 2.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.netapp_unified_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ec2_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.netapp_unified_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ami.unified_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet_ids.monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.unified_manager](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The shorthand for the AWS account | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | Name for the application being deployed | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The AWS account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The shorthand for the AWS region | `string` | n/a | yes |
| <a name="input_unified_manager_company_name"></a> [unified\_manager\_company\_name](#input\_unified\_manager\_company\_name) | Company name string to be passed to NetApp module for naming and setup of Unified Manager | `string` | n/a | yes |
| <a name="input_unified_manager_instance_type"></a> [unified\_manager\_instance\_type](#input\_unified\_manager\_instance\_type) | instance type to be used for the NetApp Unified Manager EC2 instance | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault | `string` | n/a | yes |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | Name of the AMI to use for the Unified Manager Server | `string` | `"centos7-base-*"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->