AWSTOOLS_APP_NAME				:= aws-tools
AWSTOOLS_DOCKER_IMAGE_BASE 		:= amazon/aws-cli:$(AWSCLI_VERSION)
AWSTOOLS_VERSION				?= developer
AWSTOOLS_SOURCE_HOST_DIR		:= $(shell pwd)
AWSTOOLS_DOCKER_FILE			:= $(shell pwd)/docker/aws-tools.dockerfile
AWSTOOLS_IMAGE_TAG				:= $(AWSTOOLS_APP_NAME):$(AWSTOOLS_VERSION)

.PHONY awstools:build
awstools\:build:
	@$(DOCKER_BUILD_CMD) $(AWSTOOLS_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(AWSTOOLS_DOCKER_FILE) -t $(AWSTOOLS_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(AWSTOOLS_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(AWSTOOLS_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)
