resource "google_service_account" "developer" {
  account_id   = "developer"
  display_name = "Developer Service Account"
}

resource "google_container_cluster" "dev" {
  name     = "development"
  location = var.zone

  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${data.google_project.assignment.project_id}.svc.id.goog"
  }

  node_config {
      workload_metadata_config {
        mode = "GKE_METADATA"
      }
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      maximum = "32"
      minimum = "1"
    }
    resource_limits {
      resource_type = "memory"
      maximum = "32"
      minimum = "1"
    }
    auto_provisioning_defaults {
      management {
        auto_upgrade = true
        auto_repair = true
      }
    }
  }
}

resource "google_container_node_pool" "primary" {
  name       = "primary"
  location   = var.zone
  cluster    = google_container_cluster.dev.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-micro"

    service_account = google_service_account.developer.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_dns_managed_zone" "personal" {
  name        = "personal"
  dns_name    = "arsalen.xyz."
  description = "Personal DNS zone"
}

data "google_client_config" "provider" {}