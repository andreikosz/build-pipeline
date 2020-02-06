
variable "cluster-name" {
    description = "cluster name"
    default  ="my-gke-cluster"
 
  
}

variable "cluster-username" {
  description = "username to access cluster"
  default = ""
 
}


variable "cluster-password" {
  description = "password to access cluster"
  default = ""
 
}

variable "resource-flag" {
  default = "0"
  
}

resource "google_container_cluster" "primary" {
  name     = var.cluster-name
  location = "us-central1-a"
  count = var.resource-flag == "1" ? 1:0
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = var.cluster-username
    password = var.cluster-password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  count = var.resource-flag == "1" ? 1:0
  cluster    = google_container_cluster.primary[0].name
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}