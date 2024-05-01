provider "aws" {
  region = "ap-northeast-1"

  assume_role {
    role_arn = "arn:aws:iam::234567890123:role/terraform-role"
  }
}