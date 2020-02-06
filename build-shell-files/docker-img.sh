#!/bin/bash
if cd java-vm-deploy && test -f Dockerfile; then
    echo "Using custom Dockerfile"
    if  docker build -t gcr.io/terraform-265913/java-app:latest . && docker push gcr.io/terraform-265913/java-app:test;then
        echo "Docker image pushed"
    else
        echo "Error at building docker image" && exit 1
    fi
else
    echo "Using default Dockerfile"
    if  cd .. && docker build -f build-pipeline/default-build-files/Dockerfile -t gcr.io/terraform-265913/java-app:latest . && docker push gcr.io/terraform-265913/java-app:latest;then
        echo "Docker image pushed"
    else
        echo "Error at building docker image" && exit 1
    fi
fi
