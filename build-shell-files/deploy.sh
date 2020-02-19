#!/bin/bash
if [[ $1 = "0" ]];then
    if [[ $2 = "java" ]];then
        if ! (cd app-folder && gcloud compute scp ./build/libs/spring-boot-app.jar andreikosz_96@my-instance-2: --zone=us-central1-a); then
            echo "Could not copy file to the VM instance " && exit 1
        else
             echo "Files deployed to VM instance"
        fi
    elif [[ $2 = "python" ]];then
        if ! (cd app-folder && gcloud compute scp ./backend.py andreikosz_96@my-instance-2: --zone=us-central1-a); then
            echo "Could not copy file to the VM instance " && exit 1
        else
             echo "Files deployed to VM instance"
        fi
    fi
elif [[ $1 = "1" ]];then
    if cd app-folder && test -f kubernetes.yaml; then
        echo "Using custom config yaml file "
        if cat kubernetes.yaml;then
            echo "this is kubernetes.yaml"
        if  kubectl apply -f kubernetes.yaml;then 
            echo "App deployed on kubernetes cluster"
        else 
            echo "Cloud not deploy app on cluster" && exit 1
        fi
    else
        echo "Using default config yaml file"
        if cd ../build-pipeline/default-build-files && kubectl apply -f kubernetes.yaml;then 
            echo "App deployed on kubernetes cluster"
        else 
             ls . && echo "Cloud not deploy app on cluster" && exit 1
        fi

    fi
fi 


