# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids           = data.vault_generic_secret.account_ids.data
  admin_cidrs           = values(data.vault_generic_secret.internal_cidrs.data)
  netapp_account_data   = data.vault_generic_secret.netapp_account.data
  netapp_connector_data = data.vault_generic_secret.netapp_connector.data
  netapp_cvo_data       = data.vault_generic_secret.netapp_cvo.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  # See https://docs.netapp.com/us-en/occm/reference_security_groups.html#rules-for-cloud-volumes-ontap for port details
  # Initially leaving egress open as per netapp reccomendations, we can restrict this further after initial deploys if required.
  cvo_ingress_ports = [
    { "protocol" = "tcp", "port" = 80 },
    { "protocol" = "tcp", "port" = 443 },
    { "protocol" = "tcp", "port" = 22 },
    { "protocol" = "tcp", "port" = 111 },
    { "protocol" = "tcp", "port" = 139 },
    { "protocol" = "tcp", "port" = 161, "to_port" = 162 },
    { "protocol" = "tcp", "port" = 445 },
    { "protocol" = "tcp", "port" = 635 },
    { "protocol" = "tcp", "port" = 749 },
    { "protocol" = "tcp", "port" = 2049 },
    { "protocol" = "tcp", "port" = 3260 },
    { "protocol" = "tcp", "port" = 4045, "to_port" = 4046 },
    { "protocol" = "tcp", "port" = 10000 },
    { "protocol" = "tcp", "port" = 11104, "to_port" = 11105 },
    { "protocol" = "udp", "port" = 111 },
    { "protocol" = "udp", "port" = 161, "to_port" = 162 },
    { "protocol" = "udp", "port" = 635 },
    { "protocol" = "udp", "port" = 2049 },
    { "protocol" = "udp", "port" = 4045, "to_port" = 4046 },
    { "protocol" = "udp", "port" = 4049 },
  ]

  # Create a map of vpc cidrs => ports to use as security group rules
  ingress_cidrs = length(var.vpc_ingress_cidrs) >= 1 ? setproduct(var.vpc_ingress_cidrs, local.cvo_ingress_ports) : []

  tooling_cidrs = {
    connector      = var.netapp_connector_ip,
    unifiedmanager = var.netapp_unifiedmanager_ip,
    insight        = var.netapp_insight_ip,
    snapcenter     = var.netapp_snapcenter_ip
  }

  default_tags = {
    Terraform = "true"
    Project   = "Storage"
    Region    = var.aws_region
  }
}
