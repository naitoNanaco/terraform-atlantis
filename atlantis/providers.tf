provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = local.environment
      Service     = local.name
    }
  }

  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/terraform-role"
  }
}
