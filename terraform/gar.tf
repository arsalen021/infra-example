resource "google_artifact_registry_repository" "docker_dev" {
  location      = var.region
  repository_id = "docker-development-repository"
  description   = "Docker development repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "helm_dev" {
  location      = var.region
  repository_id = "helm-development-repository"
  description   = "Helm development repository"
  format        = "DOCKER"
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_secret" "argocd" {
  metadata {
    name      = "gar-json-key"
    namespace = "argocd"
  }

  data = {
    "key.json" = base64encode(google_service_account_key.argocd.private_key)
  }

  type = "Opaque"
}