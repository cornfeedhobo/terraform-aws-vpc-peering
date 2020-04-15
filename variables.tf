provider "aws" {
  alias = "requester"
}

provider "aws" {
  alias = "accepter"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Toggle the creation and destruction of all resources in this module"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to the peering resources"
}

locals {
  tags = merge(
    var.tags,
    {
      "Terraform" = "tf_aws_vpc_cross_account_peering"
    },
  )

  # Create a list of map to support multiple CIDR blocks in accepter VPC
  requester_cidr_blocks_route_table_ids = [
    for cidr_block_route_table_id in
      flatten(
        [
          for cidr_block in var.accepter-vpc_cidr_blocks: [
            for route_table_id in var.requester-route_table_ids: {
              route_table_id = route_table_id
              cidr_block = cidr_block,
            }
          ]
        ]
    ): cidr_block_route_table_id
  ]

  # Create a list of map to support multiple CIDR blocks in requester VPC
  accepter_cidr_blocks_route_table_ids = [
    for cidr_block_route_table_id in
      flatten(
        [
          for cidr_block in var.requester-vpc_cidr_blocks: [
            for route_table_id in var.accepter-route_table_ids: {
              route_table_id = route_table_id
              cidr_block = cidr_block,
            }
          ]
        ]
    ): cidr_block_route_table_id
  ]
}

variable "requester-vpc_id" {
  type        = string
  description = "The VPC ID of the 'requester' VPC"
}

variable "requester-vpc_cidr_blocks" {
  type        = list(string)
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

variable "accepter-vpc_cidr_blocks" {
  type        = list(string)
  description = "The VPC CIDR block of the 'accepter' VPC"
}

variable "accepter-route_table_ids" {
  type        = list(string)
  description = "The VPC Route Table IDs of the 'accepter' VPC"
}

variable "accepter-allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = false
  description = "Toggle the allowance of DNS resolution through the 'requester'"
}
