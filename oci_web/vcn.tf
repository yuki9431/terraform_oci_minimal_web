# VCN
locals {
  vcn = {
    compartment_id = var.compartment_id
    cidr_block     = "192.100.0.0/16"
    display_name   = "terraform_vcn"
    dns_label      = "terraformvcn"
  }

  label = "terraform"
}

module "vcn" {
  source = "../modules/vcn"

  vcn   = local.vcn
  label = local.label
}
