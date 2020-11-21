variable "cidr_block" {
  description = "Check IP Plan and choose an appropriate cidrblock for your VPC"
}

variable "scope" {
  description = "Mostly for namespacing, will be used for name of VPC and associated resources."
}

variable "cidr_block_newbits" {
  description = "CIDR Block new bits"
  default     = 4
}

variable "private_subnet_tags" {
  description = "Additional tags for private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets"
  type        = map(string)
  default     = {}
}

locals {
  universal_tags = {
    "Provisioner" = "terraform"
    "Scope"       = var.scope
  }
}
