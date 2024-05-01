data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.name}_EcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_exec" {
  name   = "${local.name}_ECSExec"
  path   = "/application/"
  policy = data.aws_iam_policy_document.ecs_exec.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_exec.arn
}

data "aws_iam_policy_document" "assume_terraform_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["arn:aws:iam::*:role/terraform-role"]
  }
}

resource "aws_iam_policy" "assume_terraform_role" {
  name   = "${local.name}_AssumeTerraformRole"
  path   = "/application/"
  policy = data.aws_iam_policy_document.assume_terraform_role.json
}

resource "aws_iam_role_policy_attachment" "assume_terraform_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.assume_terraform_role.arn
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.name}_EcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "get_secrets" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      aws_secretsmanager_secret.github_secrets.arn,
      "${aws_secretsmanager_secret.github_secrets.arn}*",
    ]
  }
}

resource "aws_iam_policy" "get_secrets" {
  name   = "${local.name}_ECSTaskGetSecrets"
  path   = "/application/"
  policy = data.aws_iam_policy_document.get_secrets.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_get_secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.get_secrets.arn
}
