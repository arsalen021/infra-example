terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.34.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.dev.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.dev.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.dev.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.dev.master_auth[0].cluster_ca_certificate
    )
  }
}