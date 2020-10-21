# parameters for create instances
locals {
  # Set the number of fault domain your reagion
  number_fault_domain = 3

  # If the number of FDs increases, increase the definition
  fault_domain = [
    "FAULT-DOMAIN-1",
    "FAULT-DOMAIN-2",
    "FAULT-DOMAIN-3",
  ]
}

# default parameters
locals {
  instances_default = {
    region         = "ap-tokyo-1"
    compartment_id = null
    ad             = 0
    fault_domain   = 0
    private_ip     = null
    nsg_ids        = null
    shape          = null

    # see https://docs.cloud.oracle.com/en-us/iaas/images/
    # this id is Oracle-provided image "Oracle-Linux-7.8-2020.08.26-0"
    source_id      = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaadr3nqxb3xmunjeqvm5o5ywj7posqxwei6k3f7bbroytjfcpurb2a"
    source_type    = "image"

    assign_public_ip    = false
    ssh_authorized_keys = null,
    boot_volume_size_in_gbs = 50
  }
}
