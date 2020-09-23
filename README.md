


## Prerequisites
* Go >= 0.15.2
* Terraform >= 0.13.3
* gcloud / Google cloud SDK >= 311.0 
* Make >= 3.81

## Gcloud setup
Authenticate
`gcloud auth login`
Create a new project (choose a unique PROJECT_ID)
```
PROJECT_ID=my-project-id
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
gcloud services enable cloudresourcemanager.googleapis.com \
--project $PROJECT_ID
```

## Terraform setup
Init
`make tf-init`

Populate tfvars
`cp terraform.tfvars.example terraform.tfvars`

