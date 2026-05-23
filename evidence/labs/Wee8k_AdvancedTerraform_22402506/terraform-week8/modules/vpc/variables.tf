variable "vpc_cidr" {
  type        = string
  default     = "10.20.0.0/16"
  description = "CIDR block for the VPC"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC CIDR must be valid."
  }
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.20.2.0/24"
}

variable "availability_zone" {
  type    = string
  default = "eu-central-1a"
}

variable "name_prefix" {
  type    = string
  default = "week8"
}
