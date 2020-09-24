provider "google" {
  credentials = file("sa.json")
  project     = var.gcp_project_id
  region      = var.gcp_region
}
# enable cloud run api

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# users svc

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

# allow public invoke

resource "google_cloud_run_service_iam_member" "users-svc-perm" {
  service  = google_cloud_run_service.users-svc.name
  location = google_cloud_run_service.users-svc.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# locations svc

resource "google_cloud_run_service" "locations-svc" {
  name     = "locations-svc"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = var.locations_app_image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

    depends_on = [google_project_service.run]
}

# allow public invoke

resource "google_cloud_run_service_iam_member" "locations-svc-perm" {
  service  = google_cloud_run_service.locations-svc.name
  location = google_cloud_run_service.locations-svc.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# outputs

output "users-svc-url" {
  value = "${google_cloud_run_service.users-svc.status[0].url}"
}

output "locations-svc-url" {
  value = "${google_cloud_run_service.locations-svc.status[0].url}"
}
