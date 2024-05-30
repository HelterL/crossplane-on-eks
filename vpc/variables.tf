variable "cluster_name" {
  description = "Nome da Stack"
}
variable "environment" {
  description = "Nome do ambiente" 
}

variable "number_public_subnets" {
  description = "numero de subnets publicas"
}
variable "number_private_subnets" {
  description = "numerdo de subnets privadas"
}
variable "cidr_block" {
  description = "cidr block da VPC"
}