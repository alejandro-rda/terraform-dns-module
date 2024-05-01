/**
 * # Terraform Module: DNS Management
 *
 * This Terraform module is designed to dynamically create DNS records based on JSON input.
 * It supports creating A and CNAME records. Ensure JSON files are placed in the 'input-json' directory.
 *
 * ## Usage
 *
 * ### Quick Example
 *
 * ```hcl
 * module "dns_management" {
 *   source  = "./modules/terraform-dns-module"
 *   dns_server_address = "127.0.0.1"
 * }
 * ```
 *
 * ### JSON File Format
 *
 * A records JSON example:
 * ```json
 * {
 *   "zone": "example.com.",
 *   "addresses": ["192.168.1.1"],
 *   "ttl": 300,
 *   "dns_record_type": "a"
 * }
 * ```
 *
 * CNAME records JSON example:
 * ```json
 * {
 *   "zone": "example.com.",
 *   "cname": "target.example.com.",
 *   "ttl": 300,
 *   "dns_record_type": "cname"
 * }
 * ```
 */

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}

provider "dns" {
  # Configure your DNS provider
  update {
    server = var.dns_server
  }
}

# ------------------------------------------
# Write your local resources here
# ------------------------------------------

locals {
  json_files  = fileset("${path.module}/examples/exercise/input-json", "*.json")
  dns_records = { 
    for f in local.json_files : trimsuffix(basename(f), ".json") 
    => jsondecode(file("${path.module}/examples/exercise/input-json/${f}")) 
  }
}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "a_record" {
  for_each = { for k, v in local.dns_records : k => v if v.dns_record_type == "a" }

  zone      = each.value.zone
  name      = each.key
  addresses = each.value.addresses
  ttl       = each.value.ttl
}

resource "dns_cname_record" "cname_record" {
  for_each = { for k, v in local.dns_records : k => v if v.dns_record_type == "cname" }

  zone      = each.value.zone
  name      = each.key
  cname     = each.value.cname
  ttl       = each.value.ttl
}
