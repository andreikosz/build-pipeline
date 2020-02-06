package main

import (
	"context"
	"fmt"

	cloudbuild "cloud.google.com/go/cloudbuild/apiv1"
	"google.golang.org/api/option"
	cloudbuildpb "google.golang.org/genproto/googleapis/devtools/cloudbuild/v1"
)

func main() {
	ctx := context.Background()
	var flag int = 1
	var deployAppStep *cloudbuildpb.BuildStep
	var steps []*cloudbuildpb.BuildStep
	c, err := cloudbuild.NewClient(ctx, option.WithCredentialsFile("./CREDENTIALS_FILE.json"))

	if err != nil {

		fmt.Println("Error occured")
	}

	// create commands
	createResourceCommand := fmt.Sprint("sh build-pipeline/build-shell-files/infra.sh resource-flag=",flag)
	deployAppCommand :=fmt.Sprint("bash build-pipeline/build-shell-files/deploy.sh ",flag)
	
	// base steps to deploy an app
	clonePipelineRepoArgs := []string{"-c", "git clone https://github.com/andreikosz/build-pipeline.git"}
	clonePipelineStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/git",
		Id:         "Clone pipeline repo",
		Entrypoint: "/bin/sh",
		Args:       clonePipelineRepoArgs,
	}

	runInstanceArgs := []string{"-c", createResourceCommand}
	createInstanceStep := &cloudbuildpb.BuildStep{
		Name: "gcr.io/cloud-builders/docker@sha256:255467d8ede72b2af188d035ac4629ac6d0c0fe14dbd835f13cacd15da0fa4a1",
		Id:   "Start terraform module",
		Entrypoint: "/bin/sh",
		Args: runInstanceArgs,
	}

	cloneRepoArgs := []string{"./build-pipeline/build-shell-files/checkout-code.sh"}
	cloneRepoStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/git",
		Id:         "Clone repo",
		Entrypoint: "/bin/sh",
		Args:       cloneRepoArgs,
	}

	buildCodeArgs := []string{"./build-pipeline/build-shell-files/build.sh"}
	buildCodeStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/gradle@sha256:7e84b7225fe6c43457696639d0fd93e50291ef9262982c08b8d2f14e79ca2862",
		Id:         "Build code",
		Entrypoint: "/bin/sh",
		Args:       buildCodeArgs,
	}

	steps = append(steps, clonePipelineStep, createInstanceStep, cloneRepoStep, buildCodeStep)

	deployAppArgs := []string{"-c",deployAppCommand}
	

	// steps depending on the flag
	if flag == 0 {
		deployAppStep = &cloudbuildpb.BuildStep{
				Name:       "gcr.io/cloud-builders/gcloud",
				Id:         "Deploy app",
				Entrypoint: "/bin/sh",
				Args:    	deployAppArgs,
		}
		killAndStartAppProcessArgs := []string{"./build-pipeline/build-shell-files/run.sh"}
		killAndStartAppProcessStep := &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/gcloud",
			Id:         "Kill and start app process",
			Entrypoint: "/bin/sh",
			Args:       killAndStartAppProcessArgs,
		}

		 steps = append(steps,deployAppStep, killAndStartAppProcessStep)

	} else if flag == 1 {
		buildAndPushDockerImageArgs := []string{"./build-pipeline/build-shell-files/docker-img.sh"}
		buildAndPushDockerImageStep := &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/docker",
			Id:         "Build and push docker image",
			Entrypoint: "/bin/sh",
			Args:    	buildAndPushDockerImageArgs,
		}
		fetchClusterCredentialsArgs :=[]string{"./build-pipeline/build-shell-files/fetch-cluster-credentials.sh"}
		fetchClusterCredentialsStep := &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/gcloud",
			Id:         "Fetch cluster credentials",
			Entrypoint: "/bin/sh",
			Args:    	fetchClusterCredentialsArgs,
		}

		setupClusterConfigArgs :=[]string{"./build-pipeline/build-shell-files/cluster-setup.sh"}
		setupClusterConfigStep := &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/kubectl",
			Id:         "Setup cluster context",
			Entrypoint: "/bin/sh",
			Args:    	setupClusterConfigArgs,
		}
		env := []string{"CLOUDSDK_COMPUTE_ZONE=us-central1-a", "CLOUDSDK_CONTAINER_CLUSTER=my-cluster"}
		deployAppStep = &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/kubectl",
			Id:         "Deploy app",
			Entrypoint: "/bin/sh",
			Env: 		env,
			Args:    	deployAppArgs,
		}
		steps = append(steps, buildAndPushDockerImageStep, fetchClusterCredenitals, setupClusterConfigStep, deployAppStep)

	}

	build := &cloudbuildpb.Build{
		Steps: steps,
	}
	buildReq := &cloudbuildpb.CreateBuildRequest{

		ProjectId: "terraform-265913",
		Build:     build,
	}

	resp, err := c.CreateBuild(ctx, buildReq)
	if err != nil {

		fmt.Println(err)
	}
	_ = resp
}
