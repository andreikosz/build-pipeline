#!/bin/bash
if !  gcloud container clusters get-credentials my-cluster --project terraform-265913 --zone us-central1-a;then
    echo "Cluster credentials could not be fetched" && exit 1
else
    echo "Cluster credentials fetched"
fi