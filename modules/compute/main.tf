# availability domains
data "oci_identity_availability_domains" "this" {
  compartment_id = var.compartment_id
}

# Instance
resource "oci_core_instance" "this" {
  for_each            = var.instances

  compartment_id      = each.value.compartment_id
  availability_domain = each.value.ad != null ? data.oci_identity_availability_domains.this.availability_domains[each.value.ad].name : data.oci_identity_availability_domains.this.availability_domains[local.instances_default.ad].name

  fault_domain        = each.value.fault_domain != null ? local.fault_domain[each.value.fault_domain] : local.fault_domain[local.instances_default.fault_domain] # = FAULT-DOMAIN-x

  display_name        = each.key
  shape               = each.value.shape != null ? each.value.shape : local.instances_default.shape

  create_vnic_details {
    assign_public_ip  = each.value.assign_public_ip
    private_ip        = each.value.private_ip 

    # nic名はインスタンス名と同じにする
    display_name      = each.key
    nsg_ids           = each.value.nsg_ids
    subnet_id         = each.value.subnet_id
  }

  metadata = {
    ssh_authorized_keys = file(each.value.ssh_authorized_keys)
  }

  source_details {
    source_id               = each.value.source_id != null ? each.value.source_id : local.instances_default.source_id
    source_type             = each.value.source_type != null ? each.value.source_type : local.instances_default.source_type
    boot_volume_size_in_gbs = each.value.boot_volume_size_in_gbs
  }

  # true: destroyコマンドで削除不可 false: destroyコマンドで削除可能
  lifecycle {
    prevent_destroy = false 
  }
}