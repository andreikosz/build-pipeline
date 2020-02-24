#!/bin/bash
if  test -f app-folder/Dockerfile && test -f app-folder/kubernetes.yaml.tpl && cd app-folder; then
    echo "Using custom build"
    DOCKER_IMG_BASE="gcr.io/terraform-265913/app:"
    NEW_UUID=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
    DOCKER_IMG_FULL_NAME="$DOCKER_IMG_BASE$NEW_UUID"

    if  docker build -t $DOCKER_IMG_FULL_NAME . && docker push $DOCKER_IMG_FULL_NAME;then
        echo "Docker image pushed"
        if sed -e "s%DOCKER_IMG%$DOCKER_IMG_FULL_NAME%g" kubernetes.yaml.tpl > kubernetes.yaml;then
            echo "Generate kubernetes.yaml file"
        else
            echo "Failed to generate yaml file" && exit 1
        fi
    else
        echo "Error at building docker image" && exit 1
    fi
else
    echo "Using default Dockerfile"
    if [[ $1 = "java8" ]]; then
        source build-shell-files/docker-shells/java8-docker.sh
    elif [[ $1 = "python3" ]];then
        source build-shell-files/docker-shells/python3-docker.sh
    fi
fi
