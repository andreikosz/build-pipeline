
variable "instance-name" {
  description = "name of you compute instace "
  default     = "default-name"
 
}

variable "instance-zone" {
  description = "zone where your vm will run"
  default     = "us-central1-a"
}

variable "instance-machine-type" {
  description = "type of your vm"
  default     = "f1-micro"
  
}

resource "google_compute_instance" "myinstance" {
  name         = var.instance-name
  zone         = var.instance-zone
  machine_type = var.instance-machine-type

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      type  = "pd-ssd"
      size  = 10
    }
  }
  network_interface {

    network = "default"

    access_config {

    }
  }
   metadata_startup_script = file("./modules/instance-module/startup-script.sh")
 
}

resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "my-network"
}

