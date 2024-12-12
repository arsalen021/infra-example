terraform {
  backend "gcs" {
    bucket  = "infra-example"
    prefix  = "terraform/assignment"
  }
}
