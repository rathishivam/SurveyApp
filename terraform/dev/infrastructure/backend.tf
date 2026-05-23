terraform {
  backend "s3" {
    bucket = "survey-terraform-state"
    key    = "dev/infrastructure/terraform.tfstate"
    region = "ap-south-1"
  }
}
