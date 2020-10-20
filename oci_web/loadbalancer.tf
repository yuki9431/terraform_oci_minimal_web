# load balancer
locals {
  lb_options = {
    display_name          = "terraform_lb"
    compartment_id        = null
    shape                 = "10Mbps-Micro"
    subnet_ids            = [module.subnets.instances.public_subnet.id]
    private               = false
    nsg_ids               = null
    defined_tags          = null
    freeform_tags         = null
  }

  health_checks = {
    basic_http = {
      protocol            = "HTTP"
      interval_ms         = 1000
      port                = 80
      response_body_regex = ".*"
      retries             = 3
      return_code         = 200
      timeout_in_millis   = 3000
      url_path            = "/"
    }
  }

  backend_sets = {
    web = {
      policy              = "ROUND_ROBIN"
      health_check_name   = "basic_http"
      enable_persistency  = false
      enable_ssl          = false
      
      cookie_name         = null
      disable_fallback    = null
      certificate_name    = null
      verify_depth        = null
      verify_peer_certificate = null

      backends = {
        web01 = {
          ip              = cidrhost(local.private_cidr_block, 2)
          port            = 80
          backup          = false
          drain           = false
          offline         = false
          weight          = 1
        },
        web02 = {
          ip              = cidrhost(local.private_cidr_block, 3)
          port            = 80
          backup          = false
          drain           = false
          offline         = false
          weight          = 1
        }
      }
    }
  }

  listeners = {
    web                  = {
      default_backend_set_name = "web"
      port                = 80
      protocol            = "HTTP"
      idle_timeout        = 180
      hostnames           = null
      path_route_set_name = null
      rule_set_names      = null
      enable_ssl          = false
      certificate_name    = null
      verify_depth        = 5
      verify_peer_certificate = true
    }
  }
}

module "load_balancer" {
  source = "git@github.com:oracle-terraform-modules/terraform-oci-tdf-lb.git"
  default_compartment_id  = var.compartment_id
  
  lb_options    = local.lb_options
  health_checks = local.health_checks
  backend_sets  = local.backend_sets
  listeners     = local.listeners
}