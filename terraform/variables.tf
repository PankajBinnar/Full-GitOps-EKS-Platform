variable "aws_region" {
  description = "Target AWS Region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment identifier (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project prefix for resources"
  type        = string
  default     = "online-boutique"
}

variable "vpc_cidr" {
  description = "CIDR block for the Amazon VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster"
  type        = string
  default     = "online-boutique-eks"
}

variable "cluster_version" {
  description = "Kubernetes control plane version for EKS"
  type        = string
  default     = "1.30"
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "microservices" {
  description = "List of Online Boutique microservice components"
  type        = list(string)
  default = [
    "frontend",
    "cartservice",
    "productcatalogservice",
    "currencyservice",
    "paymentservice",
    "shippingservice",
    "emailservice",
    "checkoutservice",
    "recommendationservice",
    "adservice",
    "loadgenerator"
  ]
}

variable "tags" {
  description = "Default resource tags"
  type        = map(string)
  default = {
    Project     = "OnlineBoutique"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
