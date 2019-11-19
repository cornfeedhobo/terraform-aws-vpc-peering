provider "aws" {
  alias = "requester"
}

provider "aws" {
  alias = "accepter"
}

variable "enabled" {
  default     = true
  description = "Toggle the creation and destruction of all resources in this module"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to the peering resources"
}

locals {
  tags = merge(var.tags, map("Terraform", "tf_aws_vpc_cross_account_peering"))
}

variable "requester-vpc_id" {
  type        = string
  description = "The VPC ID of the 'requester' VPC"
}

variable "requester-vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR block of the 'requester' VPC"
}

variable "requester-route_table_ids" {
  type        = list(string)
  description = "The VPC Route Table IDs of the 'requester' VPC"
}

variable "requester-allow_remote_vpc_dns_resolution" {
  default     = false
  description = "Toggle the allowance of DNS resolution through the 'accepter'"
}

variable "accepter-account_id" {
  type        = string
  description = "The AWS Account ID of the 'requester' VPC"
}

variable "accepter-vpc_id" {
  type        = string
  description = "The VPC ID of the 'accepter' VPC"
}

variable "accepter-vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR block of the 'accepter' VPC"
}

variable "accepter-route_table_ids" {
  type        = list(string)
  description = "The VPC Route Table IDs of the 'accepter' VPC"
}

variable "accepter-allow_remote_vpc_dns_resolution" {
  default     = false
  description = "Toggle the allowance of DNS resolution through the 'requester'"
}
