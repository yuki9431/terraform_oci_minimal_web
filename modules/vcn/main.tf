locals {
  anywhere = "0.0.0.0/0"
}

# VCN
resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn.cidr_block
  compartment_id = var.vcn.compartment_id
  display_name   = var.vcn.display_name
  dns_label      = var.vcn.dns_label

  # true: destroyコマンドで削除不可 false: destroyコマンドで削除可能
  lifecycle {
      prevent_destroy = false
  }
}

resource "oci_core_default_security_list" "this" {

  # Default Security List forの中身を削除する。
  manage_default_resource_id = oci_core_vcn.this.default_security_list_id
}

# Internet Gateway
resource "oci_core_internet_gateway" "this" {
  compartment_id = var.vcn.compartment_id

  # use "this" id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.label}_igw"

  lifecycle {
      prevent_destroy = false
  }
}

# NAT Gateway
resource "oci_core_nat_gateway" "this" {
  compartment_id = var.vcn.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.label}_ngw"

  lifecycle {
      prevent_destroy = false
  }
}

# route table for internet gateway
resource "oci_core_route_table" "igw_route" {
  compartment_id      = var.vcn.compartment_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id
    destination       = local.anywhere
  }
  vcn_id              = oci_core_vcn.this.id
  display_name        = "${var.label}_route_igw"

  lifecycle {
    prevent_destroy = false
  }
}

# route table for nat gateway
resource "oci_core_route_table" "ngw_route" {
  compartment_id      = var.vcn.compartment_id

  # add nat gateway
  route_rules {
    network_entity_id = oci_core_nat_gateway.this.id
    destination       = local.anywhere
  }

  vcn_id              = oci_core_vcn.this.id
  display_name        = "${var.label}_route_ngw"

  lifecycle {
    prevent_destroy = false
  }
}

