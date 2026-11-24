module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Enable OIDC identity provider for IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # Cluster admin access permissions
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    primary = {
      name           = "${var.cluster_name}-nodegroup"
      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      subnet_ids = module.vpc.private_subnets

      labels = {
        Environment = var.environment
        Workload    = "online-boutique"
      }

      tags = merge(var.tags, {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      })
    }
  }

  tags = var.tags
}
