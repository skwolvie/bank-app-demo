# IAM policy for the load balancer controller in the EKS cluster
resource "aws_iam_policy" "lb_controller_policy" {
  depends_on = [module.eks]

  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/iam_policy.json")
}

# Fetching information about the EKS cluster (used for updating the Kubernetes provider)
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

# Fetching authentication information for the EKS cluster
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Fetching the AWS account identity information
data "aws_caller_identity" "current" {
}

# Local values for OIDC provider and database credentials
locals {
  oidc_provider_url = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(local.oidc_provider_url, "https://", "")}"
}

# IAM role for the load balancer controller in the EKS cluster
resource "aws_iam_role" "lb_controller_role" {
  depends_on = [module.eks]

  name = "AWSLoadBalancerControllerRole"
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.json.tpl", {
    oidc_provider_arn = local.oidc_provider_arn
    oidc_provider_url = local.oidc_provider_url
    cluster_name      = module.eks.cluster_name
  })
}

# Attaching the IAM policy to the load balancer controller role
resource "aws_iam_role_policy_attachment" "lb_controller_attach" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}

# Kubernetes service account for AWS load balancer controller
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  depends_on = [module.eks]

  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller_role.arn
    }
  }
}

# Helm release for deploying the AWS load balancer controller to the EKS cluster
resource "helm_release" "aws_lb_controller" {
  depends_on = [module.eks]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  # Setting values for the Helm chart
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  }
}
