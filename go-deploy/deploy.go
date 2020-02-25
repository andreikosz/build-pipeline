package main

import (
	"context"
	"fmt"
	cloudbuild "cloud.google.com/go/cloudbuild/apiv1"
	"google.golang.org/api/option"
	cloudbuildpb "google.golang.org/genproto/googleapis/devtools/cloudbuild/v1"
	time "github.com/golang/protobuf/ptypes/duration"
)

func main() {
	ctx := context.Background()
	var deployType string = "kubernetes"
	var appType string = "python3"
	var steps []*cloudbuildpb.BuildStep
	c, err := cloudbuild.NewClient(ctx, option.WithCredentialsFile("./CREDENTIALS_FILE.json"))

	if err != nil {

		fmt.Println("Error occured")
	}

	//base steps for all deployments
	initBaseSteps(&steps, appType, deployType)

	// steps depending on the deployType
	if deployType == "vm" {
		vmDeploy(&steps, appType, deployType)
		

	} else if deployType == "kubernetes" {
		kubernetesDeploy(&steps, appType, deployType)

	}

	// setting the context timeout to 20 minutes because cluster creation can take a long time
	duration := &time.Duration{
		Seconds: 1200,
	}

	//creating the build with the created steps and the timeout
	build := &cloudbuildpb.Build{
		Steps: steps,
		Timeout: duration,
	}

	// creating build request
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

/*this function sets the base steps of every deployment. steps parameter is passed by it's address so this function can append steps and to change the
value of steps. appType*/
func initBaseSteps(steps *[]*cloudbuildpb.BuildStep, appType string, deployType string){

	// this step clones the build pipeline repo where all the files required for the deploy are located
	clonePipelineRepoArgs := []string{"-c", "git clone https://github.com/andreikosz/build-pipeline.git"}
	clonePipelineStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/git",
		Id:         "Clone pipeline repo",
		Entrypoint: "/bin/sh",
		Args:       clonePipelineRepoArgs,
	}

	// this step creates the infrastructure required for the deploy ( vm or kubernetes cluster in this case)
	createInfrastructureCommand := fmt.Sprint("sh build-pipeline/build-shell-files/infra.sh deploy-type=",deployType)
	createInfrastructureArgs := []string{"-c", createInfrastructureCommand}
	createInfrastructureStep := &cloudbuildpb.BuildStep{
		Name: "gcr.io/cloud-builders/docker@sha256:255467d8ede72b2af188d035ac4629ac6d0c0fe14dbd835f13cacd15da0fa4a1",
		Id:   "Start terraform module",
		Entrypoint: "/bin/sh",
		Args: createInfrastructureArgs,
	}

	// this step clones the repo where the app that need to be deployed is located
	cloneRepoCommand := fmt.Sprint("bash build-pipeline/build-shell-files/checkout-code.sh ",appType)
	cloneRepoArgs := []string{"-c",cloneRepoCommand}
	cloneRepoStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/git",
		Id:         "Clone repo",
		Entrypoint: "/bin/sh",
		Args:       cloneRepoArgs,
	}

	*steps = append(*steps, clonePipelineStep, createInfrastructureStep, cloneRepoStep)

}

/* this function can append to base steps those steps that are required so the app can be deployed on a vm instance */

func vmDeploy(steps *[]*cloudbuildpb.BuildStep, appType string, deployType string){
	
	// step to build the code based on the type of app
	buildCodeCommand := fmt.Sprint("bash build-pipeline/build-shell-files/build.sh ",appType)
	buildCodeArgs := []string{"-c",buildCodeCommand}
	buildCodeStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/gradle@sha256:7e84b7225fe6c43457696639d0fd93e50291ef9262982c08b8d2f14e79ca2862",
		Id:         "Build code",
		Entrypoint: "/bin/sh",
		Args:       buildCodeArgs,
	}

	// step to deploy the app to the vm instance with ssh connection based on the deploy type and the app type
	deployAppCommand :=fmt.Sprint("bash build-pipeline/build-shell-files/deploy.sh ",deployType, " ",appType)
	deployAppArgs := []string{"-c",deployAppCommand}
	deployAppStep := &cloudbuildpb.BuildStep{
			Name:       "gcr.io/cloud-builders/gcloud",
			Id:         "Deploy app",
			Entrypoint: "/bin/sh",
			Args:    	deployAppArgs,
	}

	/*this step kill any app that run on 8080 port and runs the current app on the 8080 port. This way the app can be accessed through vm instance
	external ip on port 8080 with the help of a firewall*/

	killAndStartAppCommand := fmt.Sprint("bash build-pipeline/build-shell-files/run.sh ",appType)
	killAndStartAppProcessArgs := []string{"-c", killAndStartAppCommand }
	killAndStartAppProcessStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/gcloud",
		Id:         "Kill and start app process",
		Entrypoint: "/bin/sh",
		Args:       killAndStartAppProcessArgs,
	}

	 *steps = append(*steps,buildCodeStep, deployAppStep, killAndStartAppProcessStep)

}

func kubernetesDeploy(steps *[]*cloudbuildpb.BuildStep, appType string, deployType string){
	
	// step to build the code based on the type of app
	buildCodeCommand := fmt.Sprint("bash build-pipeline/build-shell-files/build.sh ",appType)
	buildCodeArgs := []string{"-c",buildCodeCommand}
	buildCodeStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/gradle@sha256:7e84b7225fe6c43457696639d0fd93e50291ef9262982c08b8d2f14e79ca2862",
		Id:         "Build code",
		Entrypoint: "/bin/sh",
		Args:       buildCodeArgs,
	}
	//step to build the docker image 
	dockerImageCommmand := fmt.Sprint("bash build-pipeline/build-shell-files/docker-img.sh ",appType)
	buildAndPushDockerImageArgs := []string{"-c", dockerImageCommmand}
	buildAndPushDockerImageStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/docker",
		Id:         "Build and push docker image",
		Entrypoint: "/bin/sh",
		Args:    	buildAndPushDockerImageArgs,
	}
	// step to get the cluster credentials so that we can access the cluster
	fetchClusterCredentialsArgs :=[]string{"./build-pipeline/build-shell-files/fetch-cluster-credentials.sh"}
	fetchClusterCredentialsStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/gcloud",
		Id:         "Fetch cluster credentials",
		Entrypoint: "/bin/sh",
		Args:    	fetchClusterCredentialsArgs,
	}

	// deploy app on the kubernetes cluster by applying the kubernetes.yaml
	env := []string{"CLOUDSDK_COMPUTE_ZONE=us-central1-a", "CLOUDSDK_CONTAINER_CLUSTER=my-cluster"}
	deployAppCommand :=fmt.Sprint("bash build-pipeline/build-shell-files/deploy.sh ",deployType, " ",appType)
	deployAppArgs := []string{"-c",deployAppCommand}
	deployAppStep := &cloudbuildpb.BuildStep{
		Name:       "gcr.io/cloud-builders/kubectl",
		Id:         "Deploy app",
		Entrypoint: "/bin/sh",
		Env: 		env,
		Args:    	deployAppArgs,
	}
	*steps = append(*steps, buildCodeStep, buildAndPushDockerImageStep, fetchClusterCredentialsStep, deployAppStep)
}

