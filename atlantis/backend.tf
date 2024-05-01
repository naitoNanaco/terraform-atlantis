terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-123456789012"
    key    = "atlantis/terraform.tfstate"
    region = "ap-northeast-1"

    assume_role = {
      role_arn = "arn:aws:iam::123456789012:role/terraform-role"
    }
  }
}
