terraform {
  backend "s3" {
    bucket = "survey-terraform-state"
    key    = "dev/deployment/terraform.tfstate"
    region = "ap-south-1"
  }
}
