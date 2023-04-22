variable "ssh_key" {
  type    = string
  default = "fediservices"
}

variable "instance_type" {
  type    = string
  default = "t4g.nano"
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
