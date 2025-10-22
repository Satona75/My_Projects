variable "cloudflare_api_token" {
    type = string
}
variable "cloudflare_zone_id" {
    type = string
}
variable "dns_record_name" {
    type = string
}
variable "dns_record_type" {
    type = string
}
variable "dns_record_content" {
    type = string
}
variable "dns_record_ttl" {
    type = number
}
variable "dns_record_proxied" {
    type = bool
}