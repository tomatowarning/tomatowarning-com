variable "app_name" {
  type    = string
  default = "tomato-warning-com"
}
variable "owner_name" {
  type = string
}
variable "environment" {
  type    = string
  default = "develop"
}
variable "root_domain" {
  type    = string
  default = "zbmowrey.com"
}
variable "primary_region" {
  type    = string
  default = "us-east-2"
}
variable "secondary_region" {
  type    = string
  default = "us-east-1"
}
variable "web_primary_bucket" {
  type    = string
  default = "tomato-warning-com-web-primary"
}
variable "web_secondary_bucket" {
  type    = string
  default = "tomato-warning-com-web-secondary"
}
variable "web_log_bucket" {
  type    = string
  default = "tomato-warning-com-web-log"
}
variable "aaaa_records" {
  type = map(string)
  default = {}
}
variable "mx_records" {
  type = map(list(string))
  default = {}
}
variable "cname_records" {
  type = map(string)
  default = {}
}
variable "txt_records" {
  type = map(list(string))
  default = {}
}
variable "ns_records" {
  type = map(list(string))
  default = {}
}
variable "create_api_domain_name" {
  type    = bool
  default = true
}