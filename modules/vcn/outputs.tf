output "instance" {
  description = "vcn that is created"
  value       = oci_core_vcn.this
}

output "nat_gateway_id" {
  description = "id of nat gateway if it is created"
  value       = oci_core_nat_gateway.this.id
}

output "internet_gateway_id" {
  description = "id of internet gateway if it is created"
  value = oci_core_internet_gateway.this.id
}

output "igw_route_id" {
  description = "id of internet gateway route table"
  value       = oci_core_route_table.igw_route.id
}

output "ngw_route_id" {
  description = "id of VCN NAT gateway route table"
  value       = oci_core_route_table.ngw_route.id
}