output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "OpenID Connect identity provider issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "ecr_repository_urls" {
  description = "Map of microservice names to their Amazon ECR repository URLs"
  value       = { for k, v in aws_ecr_repository.microservices : k => v.repository_url }
}

output "load_balancer_controller_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller"
  value       = module.load_balancer_controller_irsa_role.iam_role_arn
}

output "external_dns_role_arn" {
  description = "IAM Role ARN for ExternalDNS"
  value       = module.external_dns_irsa_role.iam_role_arn
}

output "configure_kubectl" {
  description = "CLI command to update local kubeconfig for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
