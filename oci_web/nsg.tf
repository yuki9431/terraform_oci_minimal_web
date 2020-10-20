# general parameter
locals {
  protocol = {
    ALL = "all"
    ICMP = "1" 
    TCP = "6"
    UDP = "17"
    ICMPv6 = "58"
  }

  ipaddr = {
    anywhere = "0.0.0.0/0"
  }
}

# NSG同士で通信を許可するため、先にNSGだけ先に作成する
locals {
  empty_nsg = {
    compartment_id = null
    defined_tags   = null
    freeform_tags  = null
    ingress_rules  = null
    egress_rules   = null
    description    = null
  }

  # 各サーバのネットワークセキュリティグループを定義
  # 通信ポリシーでは、相互参照があるため先に作成する
  nsgs = {
    nsg-web   = local.empty_nsg
    nsg-lb    = local.empty_nsg
  }
}

#
# NOTE: 通信ポリシー(standalone_nsg_rules)で、相互参照があるため先に作成する
#       相互参照がない場合は、NSGと通信ルールはまとめて作成可能
#

# nsgsのリストを全て作成する
module "network_security_groups" {
  source = "git@github.com:oracle-terraform-modules/terraform-oci-tdf-network-security.git"

  default_compartment_id = var.compartment_id
  vcn_id                 = module.vcn.instance.id

  nsgs = local.nsgs
}

# NSG作成後にルールを追加する
locals {  
  rules = {
    nsg-web = {
      egress_rules = [{
        nsg_id        = module.network_security_groups.nsgs.nsg-web.id
        description   = "Egressは全て許可する。"
        stateless     = false
        protocol      = local.protocol.ALL
        dst           = local.ipaddr.anywhere
        dst_type      = "CIDR_BLOCK"
        src_port      = null
        dst_port      = null
        icmp_code     = null
        icmp_type     = null
      }]

      ingress_rules = [{
          nsg_id        = module.network_security_groups.nsgs.nsg-web.id
          description   = "LBからHTTP通信を許可する"
          stateless     = false
          protocol      = local.protocol.TCP
          src           = module.network_security_groups.nsgs.nsg-lb.id
          src_type      = "NETWORK_SECURITY_GROUP"
          src_port      = null
          dst_port = {
            min         = 80
            max         = 80
          }
          icmp_code     = null
          icmp_type     = null
      }]
    }

    nsg-lb = {
      egress_rules = [{
        nsg_id        = module.network_security_groups.nsgs.nsg-lb.id
        description   = "Egressは全て許可する。"
        stateless     = false
        protocol      = local.protocol.ALL
        dst           = local.ipaddr.anywhere
        dst_type      = "CIDR_BLOCK"
        src_port      = null
        dst_port      = null
        icmp_code     = null
        icmp_type     = null
      }]

      ingress_rules = [{
          nsg_id        = module.network_security_groups.nsgs.nsg-lb.id
          description   = "外部らHTTP通信を許可する"
          stateless     = false
          protocol      = local.protocol.TCP
          src           = local.ipaddr.anywhere
          src_type      = "CIDR_BLOCK"
          src_port      = null
          dst_port = {
            min         = 80
            max         = 80
          }
          icmp_code     = null
          icmp_type     = null
      }]
    }
  }
}

module "standalone_nsg_rules" {
  for_each = local.rules
  source   = "git@github.com:oracle-terraform-modules/terraform-oci-tdf-network-security.git"

  default_compartment_id = var.compartment_id
  vcn_id                 = module.vcn.instance.id

  standalone_nsg_rules = {
    ingress_rules = each.value.ingress_rules
    egress_rules  = each.value.egress_rules
  }
}
