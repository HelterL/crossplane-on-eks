variable "cluster_name" {
  description = "Nome da stack"
  default     = "eks_cluster"
}

variable "environment" {
  description = "Nome do ambiente"
  default     = "Terraform"
}

variable "cidr_vpc" {
  description = "value"
  default     = "10.0.0.0/16"
}

variable "number_publics_subnets" {
  description = "Quantidade de subnets publicas"
  default     = "2"
}

variable "number_private_subnets" {
  description = "Quantidade de subnets privadas"
  default     = "2"
}
