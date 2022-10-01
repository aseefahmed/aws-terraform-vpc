# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

#vpc cidr block
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

#vpc public subnets ids
output "public_subnets_ids" {
  description = "List of IDs of eks subnets"
  value       = aws_subnet.public_subnets.*.id
}

#vpc private subnets ids
output "private_subnets_ids" {
  description = "List of IDs of eks subnets"
  value       = aws_subnet.private_subnets.*.id
}


# NAT gateways
output "nat_public_id" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.aws_ng.id
}

#nat gateways public ips

output "nat_public_ip" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.aws_ng.public_ip
}


output "sandbox_id" {
  value = local.sandbox_id
}
