provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "example_dns_record" {
  zone_id = var.cloudflare_zone_id
  name = "test.satona.co.uk"
  ttl = 3600
  type = "A"
  content = "172.167.14.165"
  proxied = false
}