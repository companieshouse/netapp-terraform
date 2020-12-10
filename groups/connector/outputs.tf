resource "vault_generic_secret" "connector_client_id" {
  path = "aws-accounts/${var.aws_account}/netapp"

  data_json = <<EOT
{
  "connector-client-id": "${module.netapp_connector.occm_client_id}",
  "occm-security-group-id": "${module.netapp_connector.occm_security_group_id}"
}
EOT
}