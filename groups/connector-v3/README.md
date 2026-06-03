# NetApp Cloud Manager Connector V2

This module serves to replace the original version of the Connector. A new implementation
of the module has been included to allow migration from the old implementation without
disturbing the existing codebase/resources as part of troubleshooting reliability issues.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_netapp-cloudmanager"></a> [netapp-cloudmanager](#requirement\_netapp-cloudmanager) | 20.12 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_netapp_connector"></a> [netapp\_connector](#module\_netapp\_connector) | git::git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_connector_aws?ref=tags/1.0.50 |  |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.netapp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.netapp_connector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group_rule.cvo_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_instance.netapp_connector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet_ids.monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.netapp_account](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.netapp_connector_input](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The shorthand for the AWS account | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | Name for the application being deployed | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The AWS account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_cloud_manager_company_name"></a> [cloud\_manager\_company\_name](#input\_cloud\_manager\_company\_name) | Company name string to be passed to NetApp module for naming and setup of Cloud Manager | `string` | n/a | yes |
| <a name="input_cloud_manager_egress_ports"></a> [cloud\_manager\_egress\_ports](#input\_cloud\_manager\_egress\_ports) | List object containg protocol, port and optional to\_port | `any` | n/a | yes |
| <a name="input_cloud_manager_ingress_ports"></a> [cloud\_manager\_ingress\_ports](#input\_cloud\_manager\_ingress\_ports) | List object containg protocol, port and optional to\_port | `any` | n/a | yes |
| <a name="input_cloud_manager_instance_type"></a> [cloud\_manager\_instance\_type](#input\_cloud\_manager\_instance\_type) | instance type to be used for the NetApp Cloud Manager EC2 instance | `string` | n/a | yes |
| <a name="input_cvo_ranges"></a> [cvo\_ranges](#input\_cvo\_ranges) | A list of subnets that contain CVO infrastructure | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The shorthand for the AWS region | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault | `string` | n/a | yes |
| <a name="input_cloud_manager_set_public_ip"></a> [cloud\_manager\_set\_public\_ip](#input\_cloud\_manager\_set\_public\_ip) | Set a public IP on the NetApp Cloud Manager instance | `string` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
