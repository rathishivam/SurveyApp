project = "survey-app"
env = "dev"
vpc_name = "survey-app-vpc"
vpc_cidr = "10.1.0.0/16"
tags = {
  "Environment" = "dev"
}
enable_nat_gateway = true
public_subnets = [ {
  name="survey-public-1",
  cidr_block = "10.1.1.0/24",
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
},
    {
      name                    = "survey-public-2"
      cidr_block              = "10.1.2.0/24"
      availability_zone       = "ap-south-1b"
      map_public_ip_on_launch = true
    } ]
private_subnets = [ {
  name="survey-public-1",
  cidr_block = "10.1.3.0/24",
  availability_zone = "ap-south-1a"
},
    {
      name                    = "survey-public-2"
      cidr_block              = "10.1.4.0/24"
      availability_zone       = "ap-south-1b"
    }  ]