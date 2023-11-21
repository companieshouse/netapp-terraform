locals {
  ec2_secret_data = data.vault_generic_secret.ec2_data.data
  kms_secret_data = data.vault_generic_secret.kms_data.data

  azure_ad_ingress_rules_tcp_udp = merge(
    [
      for idx, ports in var.azure_ad_ingress_tcp_udp :
      {
        for port in ports :
        "${idx}-${port}" => {
          "port"  = port
          "cidrs" = var.azure_ad_cidrs[idx]
        }
      }
    ]...)

  azure_ad_ingress_rules_tcp = merge(
    [
      for idx, ports in var.azure_ad_ingress_tcp:
      {
        for port in ports :
        "${idx}-${port}" => {
          "port"  = port
          "cidrs" = var.azure_ad_cidrs[idx]
        }
      }
    ]...)

  azure_ad_ingress_rules_udp = merge(
    [
      for idx, ports in var.azure_ad_ingress_udp:
        {
          for port in ports:
            "${idx}-${port}" => {
              "port" = port
              "cidrs" = var.azure_ad_cidrs[idx]
              }
        }
    ]...)
  
#  Azure_ad_ingress_port_ranges_tcp_udp = [
#    { from_port = 3268, to_port = 3269, protocol = "tcp", cidr_blocks = var.azure_ad_cidrs[0] },
#    { from_port = 3268, to_port = 3269, protocol = "tcp", cidr_blocks = var.azure_ad_cidrs[1] },
#    { from_port = 137, to_port = 138, protocol = "udp", cidr_blocks = var.azure_ad_cidrs[0] },
#    { from_port = 137, to_port = 138, protocol = "udp", cidr_blocks = var.azure_ad_cidrs[1] },
#    { from_port = 49152, to_port = 65535, protocol = "-1", cidr_blocks = var.azure_ad_cidrs[0] },
#    { from_port = 49152, to_port = 65535, protocol = "-1", cidr_blocks = var.azure_ad_cidrs[1] }
#  ]
}
