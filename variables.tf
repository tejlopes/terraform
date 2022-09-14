variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_template" {
  description = "CIDR template"
  type        = string
}

variable "azs_template" {
  description = "azs template"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "private_subnets_template" {
  description = "private subnets template"
  type        = list(string)
}

variable "public_subnets_template" {
  description = "public subnets template"
  type        = list(string)
}

variable "eks_nodes_max_template" {
  description = "Número máximo de nodes do eks"
  type        = number
  default     = 1
}

variable "eks_nodes_min_template" {
  description = "Número mínimo de nodes do eks"
  type        = number
  default     = 1
}

variable "eks_nodes_desired_template" {
  description = "Número desired de nodes do eks"
  type        = number
  default     = 1
}