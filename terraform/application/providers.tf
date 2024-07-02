# Terraform block specifying the required providers and their versions
terraform {
  required_version = "~> 1.6.6"

  backend "s3" {
    bucket         = "banking-demo-terraform-state"
    key            = "application-state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "banking-demo-terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = "eu-central-1"
}


# Kubernetes provider configuration
provider "kubernetes" {
  config_path = "./kubeconfig"
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    config_path = "./kubeconfig"
  }
}

provider "tls" {
  # Configuration options
}

provider "null" {
  # Configuration options
}

provider "random" {
  # Configuration options
}
