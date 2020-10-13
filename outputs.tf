output "peering_connection_id" {
  value = [
    for r in aws_vpc_peering_connection.requester:
    r.id
  ]
}

output "peering_connection_status" {
  value = [
    for r in aws_vpc_peering_connection.requester:
    r.accept_status
  ]
}
