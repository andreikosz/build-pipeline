
variable "google-project-id" {
  description = "id of your google cloud project"

}

variable "project-region" {
  description = "region of you project"
  default     = "us-central1"
  
}

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


variable "cluster-name" {
  description = "name of cluster"
  default = "my-gke-cluster"
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
  description = "flag to create resources"
  default = 0
}



provider "google" {

  credentials = file("CREDENTIALS_FILE.json")
  project     = var.google-project-id
  region      = var.project-region

}

terraform {
  backend "gcs" {
    bucket = "andreikosz-terraform-files_2"
    prefix = "terraform-state-file"
    credentials = "CREDENTIALS_FILE.json"
  }
}

module "create-instance" {

  source = "./modules/instance-module"
  instance-name = var.instance-name
  instance-zone = var.instance-zone
  instance-machine-type = var.instance-machine-type

}

module "create-cluster" {
  
  source = "./modules/cluster-module"
  cluster-name = var.cluster-name
  cluster-username = var.cluster-username
  cluster-password = var.cluster-password
  resource-flag = var.resource-flag
}

