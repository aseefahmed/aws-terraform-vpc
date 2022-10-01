variable "environment" {
    description = "Environment Type"
    type = string
}

variable "vpc_cidr_block" {
    description = "Enter your desire CIDR range for the VPC"
    type= string
}

variable "vpc_name" {
    description = "VPC Name"
    type = string
}

variable "vpc_availability_zones" {
    type = list
}

variable "vpc_public_subnets" {
    type = list
}

variable "vpc_private_subnets" {
    type = list
}

variable "aws_region" {
    description = "AWS Region"
    type = string
}