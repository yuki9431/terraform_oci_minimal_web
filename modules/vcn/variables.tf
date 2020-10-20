# VCN
variable "vcn" {
  type = object({
    compartment_id = string
    cidr_block     = string
    display_name   = string
    dns_label      = string
  })

  default = {
    compartment_id = null
    cidr_block     = "192.168.0.0/16"
    display_name   = "oci_vcn"
    dns_label      = "ocivcn"
  }
}

# prefix for resource name
variable "label" {
  type = string
  default = "oci"
}
