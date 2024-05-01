# VPC
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "${local.name}_vpc"
  }
}

# VPC flow log
resource "aws_flow_log" "flow_log" {
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.flow_log.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}

resource "aws_s3_bucket" "flow_log" {
  bucket = "${data.aws_caller_identity.current.account_id}-${local.name}-${local.environment}-flow-log"

  force_destroy = true

  tags = {
    Name = "${local.name}_flow_log_bucket"
  }
}

data "aws_iam_policy_document" "flow_log" {
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.flow_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      aws_s3_bucket.flow_log.arn,
    ]
  }
}

resource "aws_s3_bucket_policy" "flow_log" {
  bucket = aws_s3_bucket.flow_log.id
  policy = data.aws_iam_policy_document.flow_log.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flow_log" {
  bucket = aws_s3_bucket.flow_log.id
  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "flow_log" {
  bucket = aws_s3_bucket.flow_log.bucket

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

# Subnet
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = local.subnet_cidr_public_a
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name}_public_a_subnet"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}c"
  cidr_block              = local.subnet_cidr_public_c
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name}_public_c_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}_igw"
  }
}

# ACL
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]

  tags = {
    Name = "${local.name}_public_acl"
  }
}

resource "aws_network_acl_rule" "egress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  icmp_type      = -1
  icmp_code      = -1
}

resource "aws_network_acl_rule" "ingress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  icmp_type      = -1
  icmp_code      = -1
}

# Route Table
## public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}_public_route"
  }
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}
