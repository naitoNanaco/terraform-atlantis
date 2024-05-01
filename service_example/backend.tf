terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-234567890123"
    key    = "service_example/terraform.tfstate"
    region = "ap-northeast-1"

    assume_role = {
      role_arn = "arn:aws:iam::234567890123:role/terraform-role"
    }
  }
}