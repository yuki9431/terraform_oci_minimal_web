output "instances" {
  description = "The returned resource attributes for the VCN."
  value = {
    for x in oci_core_instance.this :
    x.display_name => x
  }
}