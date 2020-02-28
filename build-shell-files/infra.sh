#!/bin/bash
if ! docker run gcr.io/terraform-265913/terraform-vm ${1} ${2}; then
    echo "Could not create infrastructure object" && exit 1
else
    echo "Vm instance created" 
fi