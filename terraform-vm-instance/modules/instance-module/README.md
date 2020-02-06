# What does the module do

The module will create a vm instance on your Google Cloud project with the specified parameters.

# Required settings to run the module

- install terraform on your local machine
- create variables.tfvars with the following variables
	- google-project-id: the id of the project you created on Google Cloud Platform
	- project-region: region where your project is set
	- instance-name: name of your vm instance
	- instance-zone: the zone where your vm will be deployed
	- instance-machine-type: the type of your vm
- CREDENTIALS_FILE.json: you must generate this file so that google provider can access your project

# Commands to run the module

Running **terraform init** in terminal will  download the latest version of the provider in .terraform directory.

By running in terminal **terraform plan** will:

- verify syntax of main.tf
- ensure that credentials file exists
- show a preview of what will be created

To acutally apply the configuration you must run **terraform apply** and your infrastructure object should be created.

# main.tf module components

## Providers
Every root module must have a provider, in our case google, so we can use their associated resources.

Google provider requires 3 parameters:

- credential file for authentication
- google project id
- region of the project

## Resources

The resource that we used from google provider is **google-compute-instance**.

A resource block declares a resource type **google-compute-instance** and a local name "myinstance". The name is used to refer to this resource from elswhere in the same Terraform module, but has no significance outside the scope of a module. The type together with the name must be unique within a module.

Within the block body ( between { and } ) are the configuration arguments for the resource. This arguments depends on each resource type.

**google-compute-instance** resource has the following required arguments:

- name : the name of you vm instance
- zone : the zone where your vm instance will run the dafault will be 
- machine_type : the type of your vm instance which default will be f1-micro
- boot-disk : contains intialize_params
- initialize_params:
	- image: the image form which to initialize this disk in this case debian-9
	- type : GCE disk type, in this case is pd-ssd
	- size : size of the image in gigabytes in this case 10

- network_interface:
	- network: the name of the network to attach this interface to.
	- access_config: IPs via which this instance can be accessed via the Internet.

## Output

Output values are like return values of a Terraform module.

The scope of **output ip** from main.tf is to return the vm instance external IP address so that we can connect to it.
