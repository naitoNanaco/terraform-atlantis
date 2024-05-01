/**
 * # terraform_backend
 *
 * TerraformのバックエンドをS3に設定するためのリソースと、Terraformの実行に必要なIAMロールを作成します。
 */

resource "aws_s3_bucket" "backend" {
  bucket_prefix = "terraform-state-bucket"
}

resource "aws_iam_role" "terraform" {
  name               = "terraform-role"
  assume_role_policy = data.aws_iam_policy_document.asssume_role_policy.json
}

data "aws_iam_policy_document" "asssume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/atlantis_EcsTaskRole",
        "arn:aws:iam::234567890123:role/aws-reserved/sso.amazonaws.com/ap-northeast-1/AWSReservedSSO_AdministratorAccess_1234567890qwerty",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
