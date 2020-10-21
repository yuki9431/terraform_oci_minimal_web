# Instance variables
variable "instances" {
  type = map(object({
    region                  = string,
    compartment_id          = string,
    ad                      = number,
    fault_domain            = number,

    private_ip              = string,
    shape                   = string,
    nsg_ids                 = list(string),
    subnet_id               = string,

    source_id               = string,
    source_type             = string,

    assign_public_ip        = bool,
    ssh_authorized_keys     = string,
    boot_volume_size_in_gbs = number,
  }))
}

variable "compartment_id" {
  type = string
  description = "compartment id where to create all resources"
}
