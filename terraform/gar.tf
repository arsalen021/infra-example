resource "google_artifact_registry_repository" "docker_dev" {
  location      = var.region
  repository_id = "docker-development-repository"
  description   = "Docker development repository"
  format        = "DOCKER"
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}