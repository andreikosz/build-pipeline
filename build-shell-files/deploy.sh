#!/bin/bash
if [[ $1 = "vm" ]];then
    if [[ $2 = "java8" ]];then
        source build-pipeline/build-shell-files/java-shells/deploy-vm-java8.sh
    elif [[ $2 = "python3" ]];then
        source build-pipeline/build-shell-files/python-shells/deploy-vm-python3.sh
    fi
elif [[ $1 = "kubernetes" ]];then
    source build-pipeline/build-shell-files/deploy-shells/kubernetes-deploy.sh $3
fi 


