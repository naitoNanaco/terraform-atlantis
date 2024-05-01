# ALB
resource "aws_security_group" "alb" {
  name   = "${local.name}_alb"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "alb_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = local.trusted_ips
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.trusted_ips
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_allow_to_app" {
  type                     = "egress"
  from_port                = 4141
  to_port                  = 4141
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.from_alb.id
  security_group_id        = aws_security_group.alb.id
}

# from GitHub
resource "aws_security_group" "from_github" {
  name   = "${local.name}_from_github"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "github_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.github_ip_v4
  ipv6_cidr_blocks  = local.github_ip_v6
  security_group_id = aws_security_group.from_github.id
}

# to GitHub
resource "aws_security_group" "to_github" {
  name   = "${local.name}_to_github"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "to_github" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.github_ip_v4
  ipv6_cidr_blocks  = local.github_ip_v6
  security_group_id = aws_security_group.to_github.id
}

# from ALB
resource "aws_security_group" "from_alb" {
  name   = "${local.name}_from_alb"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_http_from_alb" {
  type                     = "ingress"
  from_port                = 4141
  to_port                  = 4141
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.from_alb.id
}

# to All
resource "aws_security_group" "to_all" {
  name   = "${local.name}_to_all"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.to_all.id
}
