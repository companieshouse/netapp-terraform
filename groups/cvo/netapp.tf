module "cvo" {
  source = "git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_cvo_aws?ref=tags/1.0.0"

  name = format("%s%s", var.cvo_cluster_name, "001")

  connector_client_id = local.netapp_manager_data["connector-client-id"]
  svm_password        = var.cvo_svm_password

  vpc_id                     = data.aws_vpc.default.id
  subnet_ids                 = data.aws_subnet_ids.this.ids
  
  ingress_cidr_blocks        = [
    data.aws_vpc.vpc.cidr_block
  ]
  
  ingress_security_group_ids = [
    local.netapp_manager_data["occm-security-group-id"]
  ] 

  mediator_key_pair_name = var.cvo_mediator_key_pair_name
  cluster_floating_ips   = var.cvo_cluster_floating_ips
  route_table_ids        = data.aws_route_table.default.route_table_id

}