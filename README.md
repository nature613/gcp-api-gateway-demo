
# GCP API Gateway Demo

This repository is a companion repo for the article: [GCP API Gateway Demo with Terraform, Go and Cloud Run](https://medium.com/@didil/gcp-api-gateway-demo-with-terraform-go-cloud-run-f76148328e06)

!!! THIS IS A PROOF OF CONCEPT. NOT INTENDED FOR PRODUCTION USE !!!

## Prerequisites
* Go >= 0.15.2
* Terraform >= 0.13.3
* gcloud / Google cloud SDK >= 311.0 
* Make >= 3.81
* jq

## Env
Set env variables for the gcp project id and the region
```
PROJECT_ID=my-project-id
REGION=europe-west1
```

## Setup gcloud
Authenticate
```
gcloud auth login
```
Create a new gcp project (choose a unique PROJECT_ID)
```
gcloud projects create $PROJECT_ID
```
Create a service account
```
SERVICE_ACCOUNT=deployer
gcloud iam service-accounts create $SERVICE_ACCOUNT \
--project $PROJECT_ID
```
Grant admin role to the service account (clearly more than is actually here, we could narrow it down)
```
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
--role=roles/admin \
--project $PROJECT_ID
```
Create Service Account keys
```
gcloud iam service-accounts keys create tf/sa.json \
--iam-account $SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
--project $PROJECT_ID
```
Enable APIS
```
PROJECT_ID=$PROJECT_ID make gcp-enable-apis
```

## Build/Push containers
Build/Push users service container
```
PROJECT_ID=$PROJECT_ID make gcr-push-users
```
Build/Push locations service container
```
PROJECT_ID=$PROJECT_ID make gcr-push-locations
```

## Terraform setup
Init
```
make tf-init
```

Populate tfvars
```
cp terraform.tfvars.example terraform.tfvars
```
then modify the variables in terraform.tfvars

## Terraform deploy
Plan
```
make tf-plan
```
Apply
```
make tf-apply
```

## Deploy API Gateway
Build config
```
make build-api-gateway-config
```
Deploy the gateway
```
PROJECT_ID=$PROJECT_ID REGION=$REGION make deploy-api-gateway
```
Get gateway url
```
PROJECT_ID=$PROJECT_ID REGION=$REGION make get-gateway-url
```