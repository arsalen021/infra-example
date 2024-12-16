# Terraform
## Overview
This project contains Terraform configurations to provision GCP infrastructure.
## Structure
- **`backend.tf`**: Configures Terraform state backend (e.g. GCS) **it requires creation of GCS bucket beforehand**  
- **`providers.tf`**: Defines cloud provider configurations (e.g. google, kubernetes, helm).
- **`variables.tf`**: Declares input variables for dynamic configurations (e.g. project ID, region, zone).
- **`main.tf`**: Main file orchestrating resource provisioning (e.g. service accounts, IAM bindings, workload identity federation configuration).
- **`helm.tf`**: Deploys applications add-ons using Helm charts on Kubernetes (e.g `cert-manager`, `ingress-controller`, `external-dns`).
- **`k8s.tf`**: Install and configure Google Kubernetes Cluster and primary node pool.
- **`gar.tf`**: Configure Google Artifact Registry (e.g Helm and Docker).
## Prerequisites
- Terraform >= `1.10`
- Access to a GCP project.
- Kubernetes cluster with `kubectl` access.
## Usage
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the infrastructure:
   ```bash
   terraform plan -var-file=<your-variable-file>.tfvars
   ```
3. Apply the configuration:
   ```bash
   terraform apply -var-file=<your-variable-file>.tfvars
   ```
## Variables
Include the variables defined in variables.tf. e.g
   ```tf
   variable "project_id" {
     description = "GCP Project ID"
     type        = string
   }
   ```
## Notes
Ensure you already created a GCS bucket as a backend to store the `.tfstate` of your project.
   ```bash
   gcloud storage buckets create gs://infra-example --location <your-preferred-location>
   ```