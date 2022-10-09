TFTOOLS_APP_NAME				:= terraform-tools
TFTOOLS_DOCKER_IMAGE_BASE 		:= alpine:3.16.2
TFTOOLS_VERSION					:= $(shell date -u +"%Y%m%dT%H%M%SZ")
TFTOOLS_SOURCE_HOST_DIR			:= $(shell pwd)
TFTOOLS_DOCKER_FILE				:= $(shell pwd)/docker/terraform-tools.dockerfile
TFTOOLS_IMAGE_TAG				:= $(TFTOOLS_APP_NAME):$(TFTOOLS_VERSION)

.PHONY tftools:build
tftools\:build:
	@$(DOCKER_BUILD_CMD) $(TFTOOLS_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(TFTOOLS_DOCKER_FILE) -t $(TFTOOLS_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(TFTOOLS_DOCKER_IMAGE_BASE) \
	--build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
	--label org.opencontainers.image.version=$(TFTOOLS_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)

.PHONY tftools:push
tftools\:push:
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(DOCKER_REGISTRY)
	@docker tag $(TFTOOLS_IMAGE_TAG) $(DOCKER_REGISTRY)/$(TFTOOLS_IMAGE_TAG)
	@docker push $(DOCKER_REGISTRY)/$(TFTOOLS_IMAGE_TAG)
