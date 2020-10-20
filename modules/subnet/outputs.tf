output "instances" {
  description = "The subnet(s) created/managed."
  value = {
    for i in oci_core_subnet.this:
      i.display_name => i
  }
}
