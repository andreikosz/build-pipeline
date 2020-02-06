FROM hashicorp/terraform:full
RUN mkdir -p /src/terraform
ADD . /src/terraform
WORKDIR /src/terraform
ENTRYPOINT ["./run.sh"]
RUN chmod +x /src/terraform/run.sh

