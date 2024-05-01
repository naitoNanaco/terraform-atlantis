locals {
  name                  = "atlantis"
  environment           = "development"
  domain_name           = "atlantis.example.com"
  domain_root           = "example.com"
  github_owner_name     = "myorg"
  vpc_cidr              = "10.0.0.0/16"
  subnet_cidr_public_a  = "10.0.1.0/24"
  subnet_cidr_public_c  = "10.0.2.0/24"
  subnet_cidr_private_a = "10.0.5.0/24"
  subnet_cidr_private_c = "10.0.6.0/24"
  trusted_ips = [
    # VPC CIDR
    "192.168.10.1/24",
  ]
  github_ip_v4 = concat(
    data.github_ip_ranges.whitelist.web_ipv4,
    data.github_ip_ranges.whitelist.packages_ipv4,
  )
  github_ip_v6 = concat(
    data.github_ip_ranges.whitelist.web_ipv6,
    data.github_ip_ranges.whitelist.packages_ipv6,
  )
  tags = {
    Service     = local.name
    Environment = local.environment
  }
}
