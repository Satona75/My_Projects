provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "example_dns_record" {
  zone_id = var.cloudflare_zone_id
  name = var.dns_record_name
  ttl = var.dns_record_ttl
  type = var.dns_record_type
  content = var.dns_record_content
  proxied = var.dns_record_proxied
}