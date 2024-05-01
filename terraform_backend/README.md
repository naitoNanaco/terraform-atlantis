# terraform\_backend

TerraformのバックエンドをS3に設定するためのリソースと、Terraformの実行に必要なIAMロールを作成します。

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | =1.6.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | =5.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.terraform](https://registry.terraform.io/providers/hashicorp/aws/5.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.terraform_admin](https://registry.terraform.io/providers/hashicorp/aws/5.44.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.backend](https://registry.terraform.io/providers/hashicorp/aws/5.44.0/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.asssume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.44.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_bucket_name"></a> [backend\_bucket\_name](#output\_backend\_bucket\_name) | n/a |
| <a name="output_terraform_role_arn"></a> [terraform\_role\_arn](#output\_terraform\_role\_arn) | n/a |
