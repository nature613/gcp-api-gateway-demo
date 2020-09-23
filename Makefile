CONTAINER_REGISTRY?=quay.io
CONTAINER_REPOSITORY_USERS_APP?=didil/gcp-api-gateway-demo-users
USERS_APP_VERSION=0.1.1
USERS_APP_IMAGE=$(CONTAINER_REGISTRY)/$(CONTAINER_REPOSITORY_USERS_APP):$(USERS_APP_VERSION)

docker-build-users:
	docker build -t $(USERS_APP_IMAGE) users/

docker-push-users:
    docker push $(USERS_APP_IMAGE)

tf-init:
	terraform init tf

tf-plan:
	terraform plan -out=tf/out.tfplan tf 

tf-apply:
	terraform apply -state=tf/out.tfstate tf/out.tfplan 
