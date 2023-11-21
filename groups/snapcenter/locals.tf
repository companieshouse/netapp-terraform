locals {
  ec2_secret_data = data.vault_generic_secret.ec2_data.data
  kms_secret_data = data.vault_generic_secret.kms_data.data

  azure_ad_ingress_rules_tcp_udp = merge(
   [
    for idx, ports in var.azure_ad_ingress_tcp_udp: 
      {
        for port in ports:
          "${idx}-${port}" => {
            "port" = port
            "cidrs" = var.azure_ad_cidrs[idx]
            }
      }
   ]
  )

  azure_ad_ingress_rules_tcp = merge(
    [
      for idx, ports in var.azure_ad_ingress_tcp:
        {
          for port in ports:
            "${idx}-${port}" => {
              "port" = port
              "cidrs" = var.azure_ad_cidrs[idx]
              }
        }
    ]
  )

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
    ]
  )
}
