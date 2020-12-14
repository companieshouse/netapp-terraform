resource "vault_generic_secret" "connector_client_id" {
  path = "applications/${var.aws_account}-${var.aws_region}/netapp/connector-outputs"

  data_json = <<EOT
{
  "connector-client-id": "${module.netapp_connector.occm_client_id}",
  "occm-security-group-id": "${module.netapp_connector.occm_security_group_id}"
}
EOT
}