Terraform Module: DNS Management

## Overview
This Terraform module dynamically creates DNS records from JSON files, facilitating the management of DNS configurations
in a declarative manner using infrastructure as code principles. It is designed to be flexible, supporting the creation
of A and CNAME record types, which can be defined through JSON configuration files placed in the 'examples/exercise/input-json' directory.

The module leverages Terraform's capabilities to manage state and dependencies, ensuring that DNS records are consistently
applied and maintained across updates. It's ideal for environments where DNS records are frequently updated or where
automation of DNS management is crucial.

## Features
- **Dynamic Record Creation**: Automatically manages DNS A and CNAME records based on the content of JSON files, allowing
  for rapid updates and scalability in DNS management.
- **Support for Multiple Record Types**: Handles both A and CNAME DNS records, providing flexibility depending on the
  needs of the network or application architecture.
- **Automated Management**: Facilitates the automation of DNS record provisioning and updating, reducing manual overhead
  and minimizing the risk of human errors.
- **Extensibility**: Designed to be easily extended to support additional DNS record types or integrate with other
  Terraform modules or systems.

## Usage Example
Here is a quick example of how to use this module to manage DNS records:

```hcl
module "dns_management" {
  source = "./modules/dns_management"
  dns_server_address = "127.0.0.1"
}
```

Ensure that your JSON files are structured as follows for A records:

```json
{
  "zone": "example.com.",
  "addresses": ["192.168.1.1"],
  "ttl": 300,
  "dns_record_type": "a"
}
```

And like this for CNAME records:

```json
{
  "zone": "example.com.",
  "cname": "target.example.com.",
  "ttl": 300,
  "dns_record_type": "cname"
}
```

## Planned Enhancements
- **Terragrunt Integration**: To facilitate DRY principles and improve remote state management.
- **CI/CD Pipeline Automation**: Using GitHub Actions for automated testing, validation, and deployment.
- **Automated Testing with Terratest**: To ensure module functionalities are verified automatically after each change.
- **Code Quality Assurance with tflint**: To maintain high code standards and prevent common errors.
- **Monitoring and Logging Capabilities**: To enhance visibility into DNS changes and their impacts on the system.

By integrating these enhancements, the DNS management module will provide a more robust, secure, and efficient way
to manage DNS records in cloud-native and traditional environments alike.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_dns"></a> [dns](#requirement\_dns) | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_dns"></a> [dns](#provider\_dns) | 3.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [dns_a_record_set.a_record](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/a_record_set) | resource |
| [dns_cname_record.cname_record](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/cname_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_records"></a> [dns\_records](#input\_dns\_records) | A list of DNS records to create. Each record should specify the zone, addresses, and TTL. | <pre>list(object({<br>    zone      = string<br>    addresses = list(string)<br>    ttl       = number<br>  }))</pre> | `[]` | no |
| <a name="input_dns_server"></a> [dns\_server](#input\_dns\_server) | The DNS server IP address | `string` | `"127.0.0.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_dns_a_records"></a> [created\_dns\_a\_records](#output\_created\_dns\_a\_records) | A map of created DNS A records. |
| <a name="output_created_dns_cname_records"></a> [created\_dns\_cname\_records](#output\_created\_dns\_cname\_records) | A map of created DNS CNAME records. |
