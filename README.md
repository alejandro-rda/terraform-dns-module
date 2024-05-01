# Terraform Module: DNS Management

This Terraform module is designed to dynamically create DNS records based on JSON input.
It supports creating A and CNAME records. Ensure JSON files are placed in the 'input-json' directory.

## Usage

### Quick Example

```hcl
module "dns_management" {
  source  = "./modules/terraform-dns-module"
  dns_server_address = "127.0.0.1"
}
```

### JSON File Format

A records JSON example:
```json
{
  "zone": "example.com.",
  "addresses": ["192.168.1.1"],
  "ttl": 300,
  "dns_record_type": "a"
}
```

CNAME records JSON example:
```json
{
  "zone": "example.com.",
  "cname": "target.example.com.",
  "ttl": 300,
  "dns_record_type": "cname"
}
```

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
