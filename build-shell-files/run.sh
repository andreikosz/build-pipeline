#!/bin/bash
if ! (gcloud compute ssh andreikosz_96@my-instance-2 --zone=us-central1-a --command="fuser -k 8080/tcp");then
    echo "Could not kill app"
else
    echo "App succesfully killed"
fi

if [[ $1 = "java8" ]];then
    source build-pipeline/build-shell-files/java-shells/run-java8.sh
elif [[ $1 = "python3" ]];then
    source build-pipeline/build-shell-files/python-shells/run-python3.sh
fi