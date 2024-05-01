# atlantis

Terraformのオートメーションツールとして利用するAtlantisを構築します。

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.43.0 |
| <a name="provider_github"></a> [github](#provider\_github) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.atlantis](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.atlantis](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/ecs_task_definition) | resource |
| [aws_flow_log.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/flow_log) | resource |
| [aws_iam_policy.assume_terraform_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.get_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.assume_terraform_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_get_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/internet_gateway) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.forward_service](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.redirect_https](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/lb_target_group) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress_allow_all](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress_allow_all](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/network_acl_rule) | resource |
| [aws_route.public_igw](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route) | resource |
| [aws_route53_record.atlantis](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route53_record) | resource |
| [aws_route53_record.atlantis_cert](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route53_record) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public_a](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_c](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.alb_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.alb_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.alb_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.alb_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_secretsmanager_secret.github_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.github_secrets_dummy_value](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group) | resource |
| [aws_security_group.from_alb](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group) | resource |
| [aws_security_group.from_github](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group) | resource |
| [aws_security_group.to_all](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group) | resource |
| [aws_security_group.to_github](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_allow_http](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_allow_https](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_allow_to_app](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_egress_all](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_http_from_alb](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.github_allow_https](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.to_github](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.public_a](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/subnet) | resource |
| [aws_subnet.public_c](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.current](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.alb_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_terraform_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.flow_log](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.get_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/region) | data source |
| [aws_route53_zone.root](https://registry.terraform.io/providers/hashicorp/aws/5.43.0/docs/data-sources/route53_zone) | data source |
| [github_ip_ranges.whitelist](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/ip_ranges) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
