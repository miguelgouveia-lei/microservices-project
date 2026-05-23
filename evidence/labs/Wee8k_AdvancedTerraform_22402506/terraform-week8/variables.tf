variable "aws_region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  default = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.30.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.30.2.0/24"
}

variable "availability_zone" {
  default = "eu-central-1a"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  type = string
}

variable "allowed_ports" {
  default = [22, 80]
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must have at least 8 characters."
  }
}
