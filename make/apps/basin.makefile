APP_NAME					:= basin
APP_DOCKER_IMAGE_BASE 		:= python:3.9-slim-bullseye
APP_SOURCE_HOST_DIR			:= $(shell pwd)/python/basin
APP_BUILD_DIR				:= $(shell pwd)/tmp/build/basin
APP_VERSION					:= $(shell grep 'version' $(APP_SOURCE_HOST_DIR)/pyproject.toml | cut -d'=' -f2 | tr -d '"\ ') 
DOCKER_FILE					:= $(shell pwd)/docker/basin.dockerfile
DOCKER_IMAGE_TAG			:= $(APP_NAME):$(APP_VERSION)

.PHONY basin:build
basin\:build:
	$(DOCKER_BUILD_CMD) $(APP_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(DOCKER_FILE) -t $(DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(APP_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(APP_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)

.PHONY basin:push
basin\:push:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 333594256635.dkr.ecr.eu-west-2.amazonaws.com
	docker tag $(DOCKER_IMAGE_TAG) 333594256635.dkr.ecr.eu-west-2.amazonaws.com/$(DOCKER_IMAGE_TAG)
	docker push 333594256635.dkr.ecr.eu-west-2.amazonaws.com/$(DOCKER_IMAGE_TAG)
