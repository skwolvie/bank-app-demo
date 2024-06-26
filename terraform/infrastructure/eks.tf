# EKS (Elastic Kubernetes Service) module for running Jira in a containerized environment
module "eks" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=2cb1fac31b0fc2dd6a236b0c0678df75819c5a3b"

  # Basic EKS cluster configuration
  cluster_name                   = "bank-of-anthos-demo-cluster"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true # Only for demo purposes

  # Additional cluster configuration including addons and networking
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Configuration for worker nodes in the EKS cluster
  eks_managed_node_groups = {
    eks-worker-node = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
    }
  }
}
