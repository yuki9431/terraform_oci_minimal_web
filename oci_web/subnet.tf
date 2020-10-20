# subnets
locals {
  public_cidr_block  = cidrsubnet(module.vcn.instance.cidr_block, 8, 100) # = "192.100.100.0/24"
  private_cidr_block = cidrsubnet(module.vcn.instance.cidr_block, 8, 200) # = "192.100.200.0/24"

  subnets = {
    public_subnet = {
      compartment_id             = var.compartment_id
      dns_label                  = null
      vcn_id                     = module.vcn.instance.id
      cidr_block                 = local.public_cidr_block
      prohibit_public_ip_on_vnic = false
      route_table_id             = module.vcn.igw_route_id
      dhcp_options_id            = module.vcn.instance.default_dhcp_options_id
      security_list_ids          = [module.vcn.instance.default_security_list_id]
    }

    private_subnet = {
      compartment_id             = var.compartment_id
      dns_label                  = null
      vcn_id                     = module.vcn.instance.id
      cidr_block                 = local.private_cidr_block
      prohibit_public_ip_on_vnic = true
      route_table_id             = module.vcn.ngw_route_id
      dhcp_options_id            = module.vcn.instance.default_dhcp_options_id
      security_list_ids          = [module.vcn.instance.default_security_list_id]
    }
  }
}

module "subnets" {
  source  = "../modules/subnet"

  subnets = local.subnets
}
