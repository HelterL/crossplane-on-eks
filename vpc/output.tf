output "vpc_id" {
  value = aws_vpc.main.id
}

output "number_public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "number_private_subnets_ids" {
  value = aws_subnet.private.*.id
}
