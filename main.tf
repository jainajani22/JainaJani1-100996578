provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC Creation
resource "google_compute_network" "vpc" {
  name = "flask-vpc"
}

# Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Compute Instance with Docker Container
resource "google_compute_instance" "flask_instance" {
  name         = "flask-app-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20241112"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {} # Adds a public IP
  }

  metadata = {
    "gce-container-declaration" = <<EOF
spec:
  containers:
    - name: flask-app
      image: docker.io/${var.docker_hub_username}/flask-helloworld:latest
      ports:
        - containerPort: 3000
  restartPolicy: Always
EOF
  }

  tags = ["http-server"]
}

# Firewall Rule for Port 5000
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}
