output "backend_bucket_name" {
  value = aws_s3_bucket.backend.bucket
}

output "terraform_role_arn" {
  value = aws_iam_role.terraform.arn
}
