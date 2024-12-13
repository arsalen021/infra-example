data "google_project" "assignment" {
  project_id = var.project
}

locals {
  external_dns = "principal://iam.googleapis.com/projects/${data.google_project.assignment.number}/locations/global/workloadIdentityPools/${var.project}.svc.id.goog/subject/ns/external-dns/sa/external-dns"
  jenkins = "principal://iam.googleapis.com/projects/${data.google_project.assignment.number}/locations/global/workloadIdentityPools/${var.project}.svc.id.goog/subject/ns/jenkins/sa/jenkins"
}

resource "google_project_iam_member" "external_dns" {
  member  = local.external_dns
  project = var.project
  role    = "roles/dns.reader"
}

resource "google_project_iam_member" "jenkins" {
  for_each = toset([
    "roles/storage.admin",
    "roles/artifactregistry.writer"
  ])
  role = each.key
  member  = local.jenkins
  project = var.project
}

resource "google_dns_managed_zone_iam_member" "member" {
  project      = var.project
  managed_zone = google_dns_managed_zone.personal.name
  role         = "roles/dns.admin"
  member       = local.external_dns
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project      = var.project
  repository = google_artifact_registry_repository.docker_dev.name
  role         = "roles/artifactregistry.repoAdmin"
  member       = local.jenkins
}