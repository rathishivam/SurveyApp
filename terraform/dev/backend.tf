terraform {
  backend "s3" {
    bucket = "survey-terraform-state"
    key    = "dev/tfstate"
    region = "ap-south-1"
  }
}