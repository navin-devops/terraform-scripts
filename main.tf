# Configure the Google Cloud provider
provider "google" {
  credentials = file("C:/Users/sksus/Downloads/gleaming-lead-438006-g4-489a093cd328.json")
  project     = "gleaming-lead-438006-g4"
  region      = "us-central1"
}

# Create a Virtual Private Cloud (VPC)
resource "google_compute_network" "my_vpc" {
  name                    = "my-vpc"
  auto_create_subnetworks = true
}

# Create a firewall rule for the VPC
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.my_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a VM instance
resource "google_compute_instance" "my_vm" {
  name         = "my-vm-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-9-stretch-v20191015"
    }
  }

  network_interface {
    network = google_compute_network.my_vpc.name
    access_config {
      // One to give it a public IP
    }
  }
}
