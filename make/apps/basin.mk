APP_NAME					:= basin-cli
APP_DOCKER_IMAGE_BASE 		:= python:3.9-slim-bullseye
APP_SOURCE_HOST_DIR			:= $(HOST_PROJECT_PATH)/python/basin
APP_VERSION					:= $(shell grep 'version' $(APP_SOURCE_HOST_DIR)/pyproject.toml | cut -d'=' -f2 | tr -d '"\ ') 
APP_BUILD_DIR				:= $(shell pwd)/tmp/build/$(APP_NAME)/$(APP_VERSION)
APP_DOCKER_FILE				:= $(shell pwd)/docker/python-cli-app.dockerfile
APP_DOCKER_IMAGE_TAG		:= $(APP_NAME):$(APP_VERSION)

.PHONY basin-build:
basin-build:
	@$(DOCKER_BUILD_CMD) $(APP_SOURCE_HOST_DIR) --platform $(TARGET_PLATFORM) -f $(APP_DOCKER_FILE) -t $(APP_DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(APP_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(APP_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)

.PHONY basin-info:
basin-info:
	@echo "App Name: $(APP_NAME)"
	@echo "App Version: $(APP_VERSION)"
	@echo "Docker File: $(APP_DOCKER_FILE)"
	@echo "Docker Image: $(APP_DOCKER_IMAGE_TAG)"

.PHONY basin-push:
basin-push:
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(DOCKER_REGISTRY)
	@docker tag $(APP_DOCKER_IMAGE_TAG) $(DOCKER_REGISTRY)/$(APP_DOCKER_IMAGE_TAG)
	@docker push $(DOCKER_REGISTRY)/$(APP_DOCKER_IMAGE_TAG)

.PHONY basin-start:
basin-start:
	@$(DOCKER_COMPOSE_CMD) up

.PHONY basin-stop:
basin-stop:
	@$(DOCKER_COMPOSE_CMD) down
