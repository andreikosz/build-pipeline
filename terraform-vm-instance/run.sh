#!/bin/bash
terraform init &&
terraform apply -auto-approve -var ${1} -var-file="variables.tfvars"


