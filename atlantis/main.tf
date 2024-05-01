/**
 * # atlantis
 *
 * Terraformのオートメーションツールとして利用するAtlantisを構築します。
 */

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "current" {}
data "aws_region" "current" {}
data "github_ip_ranges" "whitelist" {}
