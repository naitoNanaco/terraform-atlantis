resource "aws_secretsmanager_secret" "github_secrets" {
  name = "${local.name}/github"
}

resource "aws_secretsmanager_secret_version" "github_secrets_dummy_value" {
  secret_id = aws_secretsmanager_secret.github_secrets.id
  secret_string = jsonencode(
    {
      "app_id"          = ""
      "installation_id" = ""
      "app_key"         = ""
      "webhook_secret"  = ""
    }
  )

  lifecycle {
    ignore_changes = [secret_string]
  }
}
