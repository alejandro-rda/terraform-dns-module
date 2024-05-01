# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------

variable "dns_records" {
  description = "A list of DNS records to create. Each record should specify the zone, addresses, and TTL."
  type = list(object({
    zone      = string
    addresses = list(string)
    ttl       = number
  }))
  default = []
}

variable "dns_server" {
  description = "The DNS server IP address"
  type        = string
  default     = "127.0.0.1"
}