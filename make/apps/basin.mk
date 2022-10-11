APP_NAME					:= basin-cli
APP_DOCKER_IMAGE_BASE 		:= python:3.9-slim-bullseye
APP_SOURCE_HOST_DIR			:= $(HOST_PROJECT_PATH)/python/basin
APP_VERSION					:= $(shell grep 'version' $(APP_SOURCE_HOST_DIR)/pyproject.toml | cut -d'=' -f2 | tr -d '"\ ') 
APP_BUILD_DIR				:= $(shell pwd)/tmp/build/$(APP_NAME)/$(APP_VERSION)
DOCKER_FILE					:= $(shell pwd)/docker/python-cli-app.dockerfile
DOCKER_IMAGE_TAG			:= $(APP_NAME):$(APP_VERSION)

.PHONY basin:build
basin\:build:
	echo "$(DOCKER_BUILD_CMD) $(APP_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(DOCKER_FILE) -t $(DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(APP_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(APP_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)"

.PHONY basin:push
basin\:push:
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(DOCKER_REGISTRY)
	@docker tag $(DOCKER_IMAGE_TAG) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_TAG)
	@docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_TAG)

.PHONY basin:start
basin\:start:
	@$(DOCKER_COMPOSE_CMD) up

.PHONY basin:stop
basin\:stop:
	@$(DOCKER_COMPOSE_CMD) down
