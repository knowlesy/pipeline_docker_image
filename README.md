# ADO Pipeline to create a container image and push to a Azure Container Repo
Azure Devops Container Build Pipeline

ADO = Azure Devops

This will go through creating a my first build pipeline to create a docker image and upload it to a container

This is a lab only !

## Pre-Req's

* Azure Devops Organization and Project for testing
* terraform installed locally
* VSCode with TF Extension and Git
* AZ Cli or AZ PS Module 
* Azure Environment
* Docker - if you want to check this locally
* ADO Microsoft hosted machines enabled 
* Azure Service Principle created  and set up in Azure devops [guide](https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?view=azure-devops) , [alt guide](https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)

## Instructions

Git clone in VS Code 

You can run a test compose of the docker file to ensure it works 

     docker build -t myimage1:1.0 .
     docker images
     docker run <image id>

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/8c68fecb-4cf7-4f94-acd7-ad661b92a4a8)


cd into the TF folder 

In your VSCode Terminal 

Log in to azure [AZ CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) or [Powershell](https://learn.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-10.1.0)

Initialize TF Code

    terraform init -upgrade

Plan TF Code

    terraform plan -out main.tfplan

Apply TF Code

    terraform apply main.tfplan


Copy the output values of "acr_id" and "acr_login" into notepad or keep the session handy you will need this later 

Once this has run add your Service Principle as a contributor to the ACR if not already as part of your subscription

In ADO under your project go to project settings > service connections > new service connection > docker registry > next

Click Azure Container Reg... set to Service Principle Click Add 


Import the repo into your  project in ADO

Create a pipeline from an existing git repo and select build.yml

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/962ac5bf-324c-4550-9cb9-e8c131f28ad4)


Click Variables > New ...

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/2ff614b2-fa00-41a9-9b6a-53d8a3eba20e)

enter the name as "id" and paste the contents of "acr_id"

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/ec844a59-4e33-4d3f-98d8-3dfc66b675af)

repeat this for the variable "login" with the value from "acr_login"

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/9bcdfcca-97c0-47ee-9cdf-54a963b2fb01)

Click save and run 

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/90094e6d-8cae-4f4a-a26b-f6961b589637)

In the Azure portal you will see the metrics change in the overview of your ACR 

![image](https://github.com/knowlesy/pipeline_docker_image/assets/20459678/3c875b91-b2c8-42fb-9b81-0c2cc068493b)

To check the images being pushed do the following... 


In Azure portal or via your connection to Azure run thr following AZ Cli command to see the images stored in the repository

    az acr repository list --name <acrName> --output table

To get a list of the versions run the following substituting reponame for your image name / build shown in the previous step

    az acr repository show-tags -n <acrName> --repository <reponame> --orderby time_desc --output table


Time to clean up..... 

In your terminal locally where you ran the previos TF codes before run the following

    terraform plan -destroy -out main.destroy.tfplan
    terraform apply "main.destroy.tfplan"

References below have helped in making this example 
* [TF Azure Container Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)
* [Microsoft PS Container](https://hub.docker.com/_/microsoft-powershell)
* [Azure Container Registry Tiers](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-skus)
* [Building in ADO](https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/containers/build-image?view=azure-devops)
* [Docker task commands](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/docker-v2?view=azure-pipelines&tabs=yaml)
* [ADO Service Connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#docker-registry-service-connection)
