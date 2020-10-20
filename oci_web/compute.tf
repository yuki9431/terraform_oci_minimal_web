# compute
locals {

# 参考URL https://docs.us-phoenix-1.oraclecloud.com/images/
# 下記はOracle-provided image "Oracle-Linux-7.8-2020.08.26-0"を選択している
  image_oracle_linux7 = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaadr3nqxb3xmunjeqvm5o5ywj7posqxwei6k3f7bbroytjfcpurb2a"

  web_parameters = {
    region                  = var.region
    compartment_id          = var.compartment_id
    ad                      = null
    fault_domain            = null

    private_ip              = null
    shape                   = "VM.Standard2.1"
    nsg_ids                 = null
    subnet_id               = module.subnets.instances.private_subnet.id

    source_id               = local.image_oracle_linux7
    source_type             = "image"

    assign_public_ip        = false
    ssh_authorized_keys     = "~/.ssh/id_rsa.pub"
    boot_volume_size_in_gbs = 50
  }
}

module "computes" {
  source = "../modules/compute"
  count = 2

  compartment_id = var.compartment_id
  
  # mapのkeyがそのままインスタンス名になる
  # format("web%02d", count.index + 1) = web01
  instances = {
    format("web%02d", count.index + 1) = local.web_parameters
  }
}

