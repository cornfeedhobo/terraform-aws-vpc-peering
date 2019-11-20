data "aws_region" "accepter" {
  provider = aws.accepter
}

resource "aws_vpc_peering_connection" "requester" {
  provider = aws.requester

  count = var.enabled ? 1 : 0

  tags = merge(
    local.tags,
    {
      "Side" = "Requester"
    },
  )

  vpc_id        = var.requester-vpc_id
  peer_vpc_id   = var.accepter-vpc_id
  peer_owner_id = var.accepter-account_id
  peer_region   = data.aws_region.accepter.name
  auto_accept   = false
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider = aws.accepter

  count = var.enabled ? 1 : 0

  tags = merge(
    local.tags,
    {
      "Side" = "Accepter"
    },
  )

  vpc_peering_connection_id = aws_vpc_peering_connection.requester[0].id
  auto_accept               = true
  depends_on                = [aws_vpc_peering_connection.requester]
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.requester

  count = var.enabled ? 1 : 0

  # Options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  # https://github.com/terraform-providers/terraform-provider-aws/issues/3069
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter[0].id

  requester {
    allow_remote_vpc_dns_resolution = var.requester-allow_remote_vpc_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.accepter

  count = var.enabled ? 1 : 0

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter[0].id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter-allow_remote_vpc_dns_resolution
  }
}

resource "aws_route" "requester" {
  provider = aws.requester

  count = var.enabled ? length(var.requester-route_table_ids) : 0

  route_table_id            = var.requester-route_table_ids[count.index]
  destination_cidr_block    = var.accepter-vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[0].id
}

resource "aws_route" "accepter" {
  provider = aws.accepter

  count = var.enabled ? length(var.accepter-route_table_ids) : 0

  route_table_id            = var.accepter-route_table_ids[count.index]
  destination_cidr_block    = var.requester-vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[0].id
}
