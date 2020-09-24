USERS_APP_VERSION=0.1.1
USERS_APP_IMAGE=gcr.io/$(PROJECT_ID)/users:$(USERS_APP_VERSION)

LOCATIONS_APP_VERSION=0.1.1
LOCATIONS_APP_IMAGE=gcr.io/$(PROJECT_ID)/locations:$(LOCATIONS_APP_VERSION)

gcp-enable-apis:
	gcloud services enable cloudresourcemanager.googleapis.com --project $(PROJECT_ID)
	gcloud services enable cloudbuild.googleapis.com --project $(PROJECT_ID)
	gcloud services enable apigateway.googleapis.com --project $(PROJECT_ID)
	gcloud services enable servicemanagement.googleapis.com --project $(PROJECT_ID)
	gcloud services enable servicecontrol.googleapis.com --project $(PROJECT_ID)

gcr-push-users:
	(cd users &&\
	gcloud builds submit --tag $(USERS_APP_IMAGE) --project $(PROJECT_ID))

gcr-push-locations:
	(cd locations &&\
	gcloud builds submit --tag $(LOCATIONS_APP_IMAGE) --project $(PROJECT_ID))


tf-init:
	terraform init tf

tf-plan:
	terraform plan -out=out.tfplan tf 

tf-apply:
	terraform apply out.tfplan 

tf-destroy:
	terraform destroy tf

build-api-gateway-config:
	$(eval USERS_SVC_URL=$(shell terraform output users-svc-url))
	@echo USERS_SVC_URL: $(USERS_SVC_URL)
	$(eval LOCATIONS_SVC_URL=$(shell terraform output locations-svc-url))
	@echo LOCATIONS_SVC_URL: $(LOCATIONS_SVC_URL)	
	@sed 's,USERS_SVC_URL,$(USERS_SVC_URL),g; s,LOCATIONS_SVC_URL,$(LOCATIONS_SVC_URL),g;' api.yaml.example > api.yaml

deploy-api-gateway:
	gcloud beta api-gateway api-configs create gateway-demo \
  	--api=gateway-demo --openapi-spec=api.yaml \
  	--project=$(PROJECT_ID)
	gcloud beta api-gateway gateways create gateway-demo \
  	--api=gateway-demo --api-config=gateway-demo \
  	--location=$(REGION) --project=$(PROJECT_ID)

get-gateway-url:	
	$(eval GATEWAY_URL=$(shell gcloud beta api-gateway gateways describe gateway-demo \
	--location=$(REGION) --project=$(PROJECT_ID) \
	--format=json|jq ".defaultHostname"))
	@echo https://$(GATEWAY_URL)