# terraform-aws-vpc-peering

Terraform Module for [AWS VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html)

## Usage

```hcl-terraform
module "vpc-peering" {
  source = "cornfeedhobo/vpc-peering/aws"

  providers = {
    "aws.requester" = "aws.ash"
    "aws.accepter"  = "aws.pdx"
  }

  // see Inputs for the rest of the configuration values
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| accepter-account_id | The AWS Account ID of the 'requester' VPC | string | - | yes |
| accepter-allow_remote_vpc_dns_resolution | Toggle the allowance of DNS resolution through the 'requester' | string | `false` | no |
| accepter-route_table_ids | The VPC Route Table IDs of the 'accepter' VPC | list | - | yes |
| accepter-vpc_cidr_block | The VPC CIDR block of the 'accepter' VPC | string | - | yes |
| accepter-vpc_id | The VPC ID of the 'accepter' VPC | string | - | yes |
| enabled | Toggle the creation and destruction of all resources in this module | string | `true` | no |
| requester-allow_remote_vpc_dns_resolution | Toggle the allowance of DNS resolution through the 'accepter' | string | `false` | no |
| requester-route_table_ids | The VPC Route Table IDs of the 'requester' VPC | list | - | yes |
| requester-vpc_cidr_block | The VPC CIDR block of the 'requester' VPC | string | - | yes |
| requester-vpc_id | The VPC ID of the 'requester' VPC | string | - | yes |
| tags | Tags to attach to the peering resources | map | `<map>` | no |


## License

[MIT](LICENSE)


## Is it any good?

[Yes](http://news.ycombinator.com/item?id=3067434)
