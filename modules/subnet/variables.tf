# subnets variables
variable "subnets" {
  type = map(object({
    compartment_id             = string,
    dns_label                  = string,
    vcn_id                     = string,
    cidr_block                 = string,
    prohibit_public_ip_on_vnic = bool, # true: private subnet, false: pubilc subnet
    route_table_id             = string,
    dhcp_options_id            = string,
    security_list_ids          = list(string),
  }))
}
