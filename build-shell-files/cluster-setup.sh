#!/bin/bash

if kubectl config set-credentials admin --username=admin --pasword=Andrei_Koszorus_1996 &&
    kubectl config set-context mycontext --cluster=gke_terraform-265913_us-central1-a_my-cluster --user=admin &&
    kubectl config use-context mycontext; then

    echo "Cluster access is configured"
else
    echo "Error occured while setting up cluster" && exit 1
fi