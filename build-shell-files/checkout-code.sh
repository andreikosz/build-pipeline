#!/bin/bash
if [[ $1 = "java" ]];then
    if ! git clone https://github.com/andreikosz/java-vm-deploy.git app-folder;then
         echo "Could not clone code repo" && exit 1
    else
        echo "Code repo cloned"
    fi
elif [[ $1 = "python" ]];then
    if ! git clone https://github.com/andreikosz/python-web-app.git app-folder;then
         echo "Could not clone code repo" && exit 1
    else
        echo "Code repo cloned"
    fi
fi