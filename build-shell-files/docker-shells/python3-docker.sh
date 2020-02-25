if  docker build -f build-pipeline/default-build-files/python/Dockerfile -t gcr.io/terraform-265913/app:latest . && docker push gcr.io/terraform-265913/app:latest;then
    echo "Docker image pushed"
else
    echo "Error at building docker image" && exit 1
fi