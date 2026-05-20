# Dev environment variables
# These values are specific to the development environment.

variable "project" {
  type    = string
  default = "survey-app"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "vpc_name" {
  type    = string
  default = "survey-app-dev-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type    = map(string)
  default = {
    Environment = "dev"
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "public_subnets" {
  type = list(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = [
    {
      name                    = "public-subnet-1"
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "ap-south-1a"
      map_public_ip_on_launch = true
    },
    {
      name                    = "public-subnet-2"
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "ap-south-1b"
      map_public_ip_on_launch = true
    }
  ]
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = "private-subnet-1"
      cidr_block        = "10.0.11.0/24"
      availability_zone = "ap-south-1a"
    },
    {
      name              = "private-subnet-2"
      cidr_block        = "10.0.12.0/24"
      availability_zone = "ap-south-1b"
    }
  ]
}
