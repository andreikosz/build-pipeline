#!/bin/bash
if cd app-folder && test -f kubernetes.yaml; then
    echo "Using custom config yaml file "
    if  kubectl apply -f kubernetes.yaml;then 
        echo "App deployed on kubernetes cluster"
    else 
         echo "Cloud not deploy app on cluster" && exit 1
    fi
else
    echo "Using default config yaml file"
    if cd ../build-pipeline/default-build-files && sed -e "s%APP_PORT%$1%g" kubernetes.yaml.tpl > kubernetes.yaml && kubectl apply -f kubernetes.yaml;then 
        echo "App deployed on kubernetes cluster"
    else 
        ls . && echo "Cloud not deploy app on cluster" && exit 1
    fi
fi