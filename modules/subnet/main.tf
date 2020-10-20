# subents
resource "oci_core_subnet" "this" {
  for_each                   = var.subnets

  compartment_id             = each.value.compartment_id

  display_name               = each.key
  dns_label                  = each.value.dns_label

  vcn_id                     = each.value.vcn_id
  cidr_block                 = each.value.cidr_block
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic
  
  route_table_id             = each.value.route_table_id
  dhcp_options_id            = each.value.dhcp_options_id

  # use Default Security List
  security_list_ids          = each.value.security_list_ids

  lifecycle {
    prevent_destroy = false
  }
}