/**
 * Terraform Module: DNS Management
 *
 * ## Overview
 * This Terraform module dynamically creates DNS records from JSON files, facilitating the management of DNS configurations 
 * in a declarative manner using infrastructure as code principles. It is designed to be flexible, supporting the creation 
 * of A and CNAME record types, which can be defined through JSON configuration files placed in the 'examples/exercise/input-json' directory.
 *
 * The module leverages Terraform's capabilities to manage state and dependencies, ensuring that DNS records are consistently 
 * applied and maintained across updates. It's ideal for environments where DNS records are frequently updated or where 
 * automation of DNS management is crucial.
 *
 * ## Features
 * - **Dynamic Record Creation**: Automatically manages DNS A and CNAME records based on the content of JSON files, allowing 
 *   for rapid updates and scalability in DNS management.
 * - **Support for Multiple Record Types**: Handles both A and CNAME DNS records, providing flexibility depending on the 
 *   needs of the network or application architecture.
 * - **Automated Management**: Facilitates the automation of DNS record provisioning and updating, reducing manual overhead 
 *   and minimizing the risk of human errors.
 * - **Extensibility**: Designed to be easily extended to support additional DNS record types or integrate with other 
 *   Terraform modules or systems.
 *
 * ## Usage Example
 * Here is a quick example of how to use this module to manage DNS records:
 *
 * ```hcl
 * module "dns_management" {
 *   source = "./modules/dns_management"
 *   dns_server_address = "127.0.0.1"
 * }
 * ```
 *
 * Ensure that your JSON files are structured as follows for A records:
 *
 * ```json
 * {
 *   "zone": "example.com.",
 *   "addresses": ["192.168.1.1"],
 *   "ttl": 300,
 *   "dns_record_type": "a"
 * }
 * ```
 *
 * And like this for CNAME records:
 *
 * ```json
 * {
 *   "zone": "example.com.",
 *   "cname": "target.example.com.",
 *   "ttl": 300,
 *   "dns_record_type": "cname"
 * }
 * ```
 *
 * ## Planned Enhancements
 * - **Terragrunt Integration**: To facilitate DRY principles and improve remote state management.
 * - **CI/CD Pipeline Automation**: Using GitHub Actions for automated testing, validation, and deployment.
 * - **Automated Testing with Terratest**: To ensure module functionalities are verified automatically after each change.
 * - **Code Quality Assurance with tflint**: To maintain high code standards and prevent common errors.
 * - **Monitoring and Logging Capabilities**: To enhance visibility into DNS changes and their impacts on the system.
 *
 * By integrating these enhancements, the DNS management module will provide a more robust, secure, and efficient way 
 * to manage DNS records in cloud-native and traditional environments alike.
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
