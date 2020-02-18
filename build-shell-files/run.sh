#!/bin/bash
if !(fuser -k 8080/tcp);then
    echo "Could not kill app"
else
    echo "App succesfully killed"
fi

if [[ $1="java" ]];then
    if ! ( gcloud compute ssh andreikosz_96@my-instance-2 --zone=us-central1-a --command="java -jar spring-boot-app.jar 2 > output.txt &");then
        echo "Could not run java app" && exit 1
    else
        echo "App is running on VM external IP port 8080"
    fi
elif [[ $1="python" ]]
    if ! (gcloud compute ssh andreikosz_96@my-instance-2 --zone=us-central1-a --command="python backend.py 2 > output.txt &");then
         echo "Could not run pytho app" && exit 1
    else
        echo "App is running on VM external IP port 8080"
    fi

fi