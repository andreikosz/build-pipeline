variable "deploy-type" {
  description = "flag to create resources"
  default = "vm"
}

variable "service-name" {

  default = "backend-service"
  
}

variable "instance-name" {
    default = "my-instance-2"
  
}

variable "instance-zone" {
  default = "us-central1-a"
}

variable "dns-zone-name" {
  default = "def-zone"
  
}

variable "dns-name" {
  default = "andreikosz.tk."
}

data "kubernetes_service" "service" {
    metadata {
        name = var.service-name
    }
  
}
provider "kubernetes" {
  
}


data "google_compute_instance" "vm" {
  name = var.instance-name
  zone = var.instance-zone
}


resource "google_dns_record_set" "a" {
  name         = google_dns_managed_zone.prod.dns_name
  managed_zone = google_dns_managed_zone.prod.name
  type         = "A"
  ttl          = 300

  rrdatas = [var.deploy-type == "vm" ? data.google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : data.kubernetes_service.service.load_balancer_ingress.0.ip]
}

resource "google_dns_record_set" "cname" {
  name         = "www.${google_dns_managed_zone.prod.dns_name}"
  managed_zone = google_dns_managed_zone.prod.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [google_dns_managed_zone.prod.dns_name]
}

resource "google_dns_record_set" "nameservers" {
  name =  google_dns_managed_zone.prod.dns_name
  managed_zone = google_dns_managed_zone.prod.name
  type = "NS"
  ttl = 300
  rrdatas = ["ns-cloud-e1.googledomains.com.", "ns-cloud-e2.googledomains.com.", "ns-cloud-e3.googledomains.com.", "ns-cloud-e4.googledomains.com."]
  
}


resource "google_dns_managed_zone" "prod" {
  name     = var.dns-zone-name
  dns_name = var.dns-name

}


