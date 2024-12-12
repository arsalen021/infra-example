data "google_project" "assignment" {
  project_id = var.project
}

locals {
  member = "principal://iam.googleapis.com/projects/${data.google_project.assignment.number}/locations/global/workloadIdentityPools/${var.project}.svc.id.goog/subject/ns/external-dns/sa/external-dns"
}

resource "google_project_iam_member" "external_dns" {
  member  = local.member
  project = var.project
  role    = "roles/dns.reader"
}

resource "google_dns_managed_zone_iam_member" "member" {
  project      = var.project
  managed_zone = google_dns_managed_zone.personal.name
  role         = "roles/dns.admin"
  member       = local.member
}