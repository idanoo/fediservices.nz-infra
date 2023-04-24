variable "ssh_key" {
  type    = string
  default = "fediservices"
}

variable "instance_type" {
  type    = string
  default = "t4g.micro"
}

variable "domain" {
  type    = string
  default = "status.fediservices.nz"
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
