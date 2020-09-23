provider "google" {
  credentials = file("sa.json")
  project     = var.gcp_project_id
  region      = var.gcp_region
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_cloud_run_service" "users-svc" {
  name     = "users-svc"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = var.users_app_image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

    depends_on = [google_project_service.run]
}

output "users-svc-url" {
  value = "${google_cloud_run_service.users-svc.status[0].url}"
}
