# CVO Infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 4.0 |
| <a name="requirement_netapp-cloudmanager"></a> [netapp-cloudmanager](#requirement\_netapp-cloudmanager) | 24.5.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cvo2"></a> [cvo2](#module\_cvo2) | git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_cvo_aws | tags/1.0.278 |
| <a name="module_netapp_secondary_security_group"></a> [netapp\_secondary\_security\_group](#module\_netapp\_secondary\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.netapp_mediator_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.cvo_nfs_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.cvo_data_cifs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.cvo_data_nfs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cvo_data_cifs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cvo_data_nfs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ec2_managed_prefix_list.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet_ids.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.netapp_new_account](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.netapp_new_connector](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.netapp_new_cvo](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The shorthand for the AWS account | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The AWS account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_capacity_tier"></a> [capacity\_tier](#input\_capacity\_tier) | (Optional) Whether to enable data tiering for the first data aggregate: ['S3','NONE']. The default is 'NONE'. | `string` | `"NONE"` | no |
| <a name="input_cifs_client_cidrs"></a> [cifs\_client\_cidrs](#input\_cifs\_client\_cidrs) | A list of CIDRs requiring CIFS access from outside of the home VPC | `list(any)` | `[]` | no |
| <a name="input_cifs_ports"></a> [cifs\_ports](#input\_cifs\_ports) | A list of ports and protocols used for CIFS client access | `list(any)` | <pre>[<br>  {<br>    "port": 137,<br>    "protocol": "udp",<br>    "to_port": 138<br>  },<br>  {<br>    "port": 139,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "port": 445,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| <a name="input_client_ips"></a> [client\_ips](#input\_client\_ips) | The full CIDR formatted IPs of the client networks that need to access CVO | `list(any)` | n/a | yes |
| <a name="input_client_ips_icmp"></a> [client\_ips\_icmp](#input\_client\_ips\_icmp) | The full CIDR formatted IPs of the client networks that need ICMP connectivity to CVO | `list(any)` | n/a | yes |
| <a name="input_client_ports"></a> [client\_ports](#input\_client\_ports) | A list of ports to allow from on-premise ranges | `list(any)` | `[]` | no |
| <a name="input_connector_account_access_id"></a> [connector\_account\_access\_id](#input\_connector\_account\_access\_id) | The credential ID as found in the NetApp Connector credentials page, custom per account and must exist before deployment | `string` | `null` | no |
| <a name="input_cvo2_name"></a> [cvo2\_name](#input\_cvo2\_name) | Name for the resources table being created for the upgrade | `string` | n/a | yes |
| <a name="input_cvo_dns_name"></a> [cvo\_dns\_name](#input\_cvo\_dns\_name) | The dns name for the nfs vip | `string` | n/a | yes |
| <a name="input_cvo_dns_record"></a> [cvo\_dns\_record](#input\_cvo\_dns\_record) | The dns record used for the cvo nfs vip dns | `string` | n/a | yes |
| <a name="input_cvo_ebs_volume_size"></a> [cvo\_ebs\_volume\_size](#input\_cvo\_ebs\_volume\_size) | Initial aggregate size, we are limiting this to 100GB as we want all used aggregates to be create purposefully in the same way i.e. we are not using this aggregate at all | `number` | `1` | no |
| <a name="input_cvo_ebs_volume_size_unit"></a> [cvo\_ebs\_volume\_size\_unit](#input\_cvo\_ebs\_volume\_size\_unit) | Unit choice for volume size, can be TB or GB. In this case we are defaulting to GB so that we can create the smallest possible aggregate on first launch | `string` | `"TB"` | no |
| <a name="input_cvo_floating_ips"></a> [cvo\_floating\_ips](#input\_cvo\_floating\_ips) | List of Floating IPs to use if HA mode is set to 'FloatingIP'. If provided, should be of length 4 and contain 4 IP addresses outside of the VPC range. | `list(string)` | <pre>[<br>  null,<br>  null,<br>  null,<br>  null<br>]</pre> | no |
| <a name="input_cvo_instance_type"></a> [cvo\_instance\_type](#input\_cvo\_instance\_type) | Instance Type to be used for the CVO Nodes, different types allowed depending on license type chosen | `string` | n/a | yes |
| <a name="input_cvo_is_ha"></a> [cvo\_is\_ha](#input\_cvo\_is\_ha) | Is this going to be a HA deployment or Standalone | `bool` | n/a | yes |
| <a name="input_cvo_license_type"></a> [cvo\_license\_type](#input\_cvo\_license\_type) | The license type for the deployment, can be standalone or HA with different licenses providing different maximum storage allowance | `string` | n/a | yes |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | (Optional) The EBS volume type for the first data aggregate ['gp3','gp2','io1','st1','sc1']. The default is 'gp3'. | `string` | `"gp3"` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | the provisioned Iops value for the gp3 volume types | `number` | `12000` | no |
| <a name="input_mediator_sg"></a> [mediator\_sg](#input\_mediator\_sg) | The mediator secuirty group name lookup | `string` | `null` | no |
| <a name="input_netapp_connector_ip"></a> [netapp\_connector\_ip](#input\_netapp\_connector\_ip) | The full CIDR formatted IP of the Connector instance so that we can allow it to access CVO security groups | `string` | `"10.44.13.97/32"` | no |
| <a name="input_netapp_insight_ip"></a> [netapp\_insight\_ip](#input\_netapp\_insight\_ip) | The full CIDR formatted IP of the Unified Manager instance so that we can allow it to access CVO security groups | `string` | `"10.44.13.68/32"` | no |
| <a name="input_netapp_snapcenter_ip"></a> [netapp\_snapcenter\_ip](#input\_netapp\_snapcenter\_ip) | The full CIDR formatted IP of the SnapCentre instance so that we can allow it to access CVO security groups | `string` | `"10.44.12.150/32"` | no |
| <a name="input_netapp_unifiedmanager_ip"></a> [netapp\_unifiedmanager\_ip](#input\_netapp\_unifiedmanager\_ip) | The full CIDR formatted IP of the Unified Manager instance so that we can allow it to access CVO security groups | `string` | `"10.44.13.208/32"` | no |
| <a name="input_nfs_cifs_cidrs"></a> [nfs\_cifs\_cidrs](#input\_nfs\_cifs\_cidrs) | A list of CIDRs to allow NFS/CIFS access from | `list(any)` | `[]` | no |
| <a name="input_nfs_cifs_ports"></a> [nfs\_cifs\_ports](#input\_nfs\_cifs\_ports) | A list of ports to allow from on-premise ranges | `list(any)` | `[]` | no |
| <a name="input_nfs_client_cidrs"></a> [nfs\_client\_cidrs](#input\_nfs\_client\_cidrs) | A list of CIDRs requiring NFS access from outside of the home VPC | `list(any)` | `[]` | no |
| <a name="input_nfs_ports"></a> [nfs\_ports](#input\_nfs\_ports) | A list of ports and protocols used for NFS client access | `list(any)` | <pre>[<br>  {<br>    "port": 111,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "port": 111,<br>    "protocol": "udp"<br>  },<br>  {<br>    "port": 2049,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "port": 2049,<br>    "protocol": "udp"<br>  },<br>  {<br>    "port": 635,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "port": 635,<br>    "protocol": "udp"<br>  },<br>  {<br>    "port": 4045,<br>    "protocol": "tcp",<br>    "to_port": 4046<br>  },<br>  {<br>    "port": 4045,<br>    "protocol": "udp",<br>    "to_port": 4046<br>  },<br>  {<br>    "port": 4049,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "port": 4049,<br>    "protocol": "udp"<br>  }<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The shorthand for the AWS region | `string` | n/a | yes |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | The throughput value for the gp3 volume types | `number` | `125` | no |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault | `string` | n/a | yes |
| <a name="input_vpc_ingress_cidrs"></a> [vpc\_ingress\_cidrs](#input\_vpc\_ingress\_cidrs) | A list of CIDR blocks to allow access, will be used with predefined port(s). | `list(string)` | `[]` | no |
| <a name="input_vpn_prefix_list_name"></a> [vpn\_prefix\_list\_name](#input\_vpn\_prefix\_list\_name) | Name of the vpn prefix list to lookup | `string` | `"vpn-cidr-ranges"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
