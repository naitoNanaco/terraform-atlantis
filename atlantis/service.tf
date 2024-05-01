# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = local.name

  tags = {
    Name = "${local.name}_ecs"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 100
  }
}

# Domain
data "aws_route53_zone" "root" {
  name = local.domain_root
}

resource "aws_route53_record" "atlantis" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}

# Certificate
resource "aws_acm_certificate" "atlantis" {
  domain_name       = local.domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "atlantis_cert" {
  for_each = {
    for dvo in aws_acm_certificate.atlantis.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root.zone_id
}

resource "aws_acm_certificate_validation" "atlantis" {
  certificate_arn         = aws_acm_certificate.atlantis.arn
  validation_record_fqdns = [for record in aws_route53_record.atlantis_cert : record.fqdn]
}

# Target Group
resource "aws_lb_target_group" "main" {
  name_prefix          = substr(local.name, 0, 6)
  port                 = 4141
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 60

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    port                = 4141
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${local.name}_target_group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ALB
resource "aws_lb" "main" {
  name               = local.name
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb.id,
    aws_security_group.from_github.id,
  ]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  tags = {
    Name = "${local.name}_alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${local.name}_alb_listner_http"
  }
}

resource "aws_lb_listener_rule" "redirect_https" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [local.domain_name]
    }
  }

  depends_on = [aws_lb.main]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.atlantis.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${local.name}_alb_listner_http"
  }
}

resource "aws_lb_listener_rule" "forward_service" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [local.domain_name]
    }
  }

  depends_on = [aws_lb.main]
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "${local.name}-${local.environment}-alb-log"

  force_destroy = true

  tags = {
    Name = "${local.name}_alb_log_bucket"
  }
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.current.arn]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.alb_log.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.alb_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [aws_s3_bucket.alb_log.arn]
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.bucket

  rule {
    id = "log"

    expiration {
      days = 90
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

# Log Stream
resource "aws_cloudwatch_log_group" "main" {
  name              = "logs/ecs/${local.name}"
  retention_in_days = 30
}

# Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = local.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name              = "app"
      image             = "ghcr.io/runatlantis/atlantis:latest"
      cpu               = 256
      memoryReservation = 512
      essential         = true
      portMappings = [
        {
          containerPort = 4141
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "app"
          awslogs-group         = aws_cloudwatch_log_group.main.name
        },
      },
      environment = [
        {
          name  = "ATLANTIS_ALLOW_DRAFT_PRS"
          value = "true"
        },
        {
          name  = "ATLANTIS_AUTOMERGE"
          value = "true"
        },
        {
          name  = "ATLANTIS_REPO_ALLOWLIST"
          value = "github.com/${local.github_owner_name}/*"
        },
        {
          name  = "ATLANTIS_WRITE_GIT_CREDS"
          value = "true"
        },
        {
          name  = "ATLANTIS_PORT"
          value = "4141"
        },
        {
          name  = "ATLANTIS_ATLANTIS_URL"
          value = "https://${local.domain_name}/"
        },
      ]
      secrets = [
        {
          name      = "ATLANTIS_GH_APP_ID"
          valueFrom = "${aws_secretsmanager_secret.github_secrets.arn}:app_id::"
        },
        {
          name      = "ATLANTIS_GH_INSTALLATION_ID"
          valueFrom = "${aws_secretsmanager_secret.github_secrets.arn}:installation_id::"
        },
        {
          name      = "ATLANTIS_GH_APP_KEY"
          valueFrom = "${aws_secretsmanager_secret.github_secrets.arn}:app_key::"
        },
        {
          name      = "ATLANTIS_GH_WEBHOOK_SECRET"
          valueFrom = "${aws_secretsmanager_secret.github_secrets.arn}:webhook_secret::"
        },
      ],
    },
  ])

  tags = {
    Name = "${local.name}_task_definition"
  }
}

# Service
resource "aws_ecs_service" "main" {
  name                               = "main"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 1
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_execute_command             = true
  enable_ecs_managed_tags            = true
  propagate_tags                     = "SERVICE"

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "app"
    container_port   = 4141
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 100
  }

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_c.id,
    ]
    security_groups = [
      aws_security_group.from_alb.id,
      aws_security_group.to_all.id,
    ]
    assign_public_ip = true
  }

  tags = {
    Name = "${local.name}_service"
  }
}
