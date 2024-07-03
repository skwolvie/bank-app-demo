# Bank of Anthos AWS Demo

This project is an AWS-adapted version of the Google Cloud Bank of Anthos demo application. It demonstrates a cloud-native banking application running on Amazon EKS (Elastic Kubernetes Service).

## Project Structure

```
.
├── src/                      # Source code for microservices
│   ├── accounts/             # Accounts-related services
│   ├── frontend/             # Frontend service
│   └── ledger/               # Ledger-related services
├── terraform/
│   ├── infrastructure/       # Terraform configs for AWS infrastructure
│   └── application/          # Terraform configs for application resources
├── kubernetes-manifests-new/ # Kubernetes manifest files
└── .github/workflows/        # GitHub Actions workflow files
```

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform (version 1.6.6 or later)
- kubectl
- An AWS account with permissions to create EKS clusters

## Setup and Deployment

### 1. Infrastructure Deployment

To deploy the AWS infrastructure run the Terraform Infrastructure Deploy pipeline or manually:


```bash
cd terraform/infrastructure
terraform init
terraform apply
```

### 2. Application Deployment

After the infrastructure is set up run the Terraform Application Deploy pipeline or manually:

```bash
cd ../application
terraform init
terraform apply
```

### 3. Kubernetes Manifests Application

Kubernetes manifests are applied automatically via GitHub Actions via the Apply Kubernetes Manifests pipeline. To manually apply the manifests:

```bash
cd kubernetes-manifests-new
kubectl apply -f .
```

## CI/CD Pipelines

This project uses GitHub Actions for continuous integration and deployment. The following workflows are implemented:

### Infrastructure and Application Deployment

1. **Terraform Infrastructure Deploy** (`terraform-infrastructure.yaml`)
   - Applies changes to the AWS infrastructure when updates are made to Terraform files in the `terraform/infrastructure/` directory.

2. **Terraform Application Deploy** (`terraform-application.yaml`)
   - Applies changes to application-specific resources when updates are made to Terraform files in the `terraform/application/` directory.

### Microservices Image Building

3. **Balance Reader Image Build** (`balancereader-image-build.yaml`)
   - Builds and pushes the Docker image for the Balance Reader service.

4. **Contacts Service Image Build** (`contacts-image-build.yaml`)
   - Builds and pushes the Docker image for the Contacts service.

5. **Frontend Image Build** (`frontend-image-build.yaml`)
   - Builds and pushes the Docker image for the Frontend service.

6. **Ledger Writer Image Build** (`ledgerwriter-image-build.yaml`)
   - Builds and pushes the Docker image for the Ledger Writer service.

7. **Transaction History Image Build** (`transactionhistory-image-build.yaml`)
   - Builds and pushes the Docker image for the Transaction History service.

8. **User Service Image Build** (`uservice-image-build.yaml`)
   - Builds and pushes the Docker image for the User service.

### Kubernetes Deployment

9. **Apply Kubernetes Manifests** (`kubernetes-manifests-apply.yaml`)
   - Automatically applies Kubernetes manifests when changes are pushed to the `kubernetes-manifests-new/` directory.
   - Can be manually triggered to deploy to a specific cluster.

To manually trigger any of these workflows:
1. Go to the Actions tab in the GitHub repository
2. Select the desired workflow
3. Click "Run workflow"
4. Provide any required inputs (e.g., cluster name for Kubernetes manifest application)

These pipelines ensure that changes to any part of the application - from infrastructure to individual microservices - are automatically built, tested, and deployed.

