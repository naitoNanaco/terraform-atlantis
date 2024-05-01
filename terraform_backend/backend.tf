terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-234567890123"
    key    = "terraform_backend/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
