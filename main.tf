terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

data "google_compute_zones" "available" {
  region = var.region
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

data "google_compute_image" "centos" {
  family  = "centos-stream-9"
  project = "centos-cloud"
}

locals {
  selected_zone = data.google_compute_zones.available.names[0]
  image         = var.os == "Ubuntu" ? data.google_compute_image.ubuntu.self_link : data.google_compute_image.centos.self_link
  provisioning  = var.provisioning_model == "SPOT" ? "SPOT" : "STANDARD"
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = local.selected_zone

  scheduling {
    provisioning_model = local.provisioning
  }

  boot_disk {
    initialize_params {
      image = local.image
      type  = var.disk_type
      size  = 50
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "allow_ssh" {
  count   = var.firewall == "ssh" ? 1 : 0
  name    = "${var.vm_name}-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_web" {
  count   = var.firewall == "webserver" ? 1 : 0
  name    = "${var.vm_name}-allow-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
