
variable "google-project-id" {
  description = "id of your google cloud project"

}

variable "project-region" {
  description = "region of you project"
  default     = "us-central1"
  
}


variable "deploy-type" {
  description = "flag to create resources"
  default = "vm"
}

variable "service-name" {

  default = "backend-service"
  
}

variable "instance-name" {
    default = "instance2"
  
}

variable "instance-zone" {
  default = "us-central1-a"
}

variable "dns-zone-name" {
  default = "def-zone"
  
}

variable "dns-name" {
  default = "andreikosz.tk"
}
variable "cluster-name" {
  default = "my-cluster"
  
}







provider "google" {

  credentials = file("CREDENTIALS_FILE.json")
  project     = var.google-project-id
  region      = var.project-region

}
data "google_client_config" "my_config" {
}

data "google_container_cluster" "my_cluster" {
  name = var.cluster-name
  zone = "us-central1-a"
}

 provider kubernetes {
    load_config_file = false
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.my_config.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,)
  }


terraform {
  backend "gcs" {
    bucket = "andreikosz-terraform-files_2"
    prefix = "terraform-dns-state-file"
    credentials = "CREDENTIALS_FILE.json"
  }
}

module "dns-entry" {
  source = "./modules/dns-module"
  deploy-type = var.deploy-type
  service-name = var.service-name
  instance-name = var.instance-name
  instance-zone = var.instance-zone
  dns-zone-name = var.dns-zone-name
  dns-name = var.dns-name
  
}




