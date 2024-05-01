# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------

output "created_dns_a_records" {
  value = {
    for record in dns_a_record_set.a_record :
    record.name => {
      addresses = record.addresses
      ttl       = record.ttl
    }
  }
  description = "A map of created DNS A records."
}

output "created_dns_cname_records" {
  value = {
    for record in dns_cname_record.cname_record :
    record.name => {
      cname = record.cname
      ttl       = record.ttl
    }
  }
  description = "A map of created DNS CNAME records."
}