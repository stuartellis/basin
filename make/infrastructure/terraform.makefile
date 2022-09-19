# Makefile for Terraform
#
# https://makefiletutorial.com

# Terraform Version

TF_VERSION			:= $(shell grep 'terraform' ./.tool-versions | cut -d' ' -f2)

# Terraform Docker Container

TF_CMD_DOCKER_IMAGE		:= hashicorp/terraform:$(TF_VERSION)

# Other Project Variables for Terraform

TF_SRC_HOST_DIR		:= $(shell pwd)
TF_BACKENDS_DIR		:= terraform/backends
TF_BACKEND_FILE		:= $(SRC_BIND_DIR)/$(TF_BACKENDS_DIR)/$(ENVIRONMENT)/$(TF_STACK).backend
TF_STACKS_DIR		:= terraform/stacks
TF_STACK_DIR		:= $(SRC_BIND_DIR)/$(TF_STACKS_DIR)/$(TF_STACK)
TF_DATA_DIR         := $(SRC_BIND_DIR)/$(TF_STACKS_DIR)/$(TF_STACK)/.terraform
TF_PLAN_FILE		:= plan-$(PROJECT_NAME)-$(ENVIRONMENT)-$(TF_STACK).tfstate
TF_VARS_DIR			:= terraform/variables
TF_VARS_FILES		:= -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/project/project.tfvars -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/environments/$(ENVIRONMENT).tfvars -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/stacks/$(TF_STACK).tfvars

TF_RUN_CMD := --rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(TF_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env TF_DATA_DIR=$(TF_DATA_DIR) \
		$(DOCKER_AWS_CREDENTIALS) \
		$(TF_CMD_DOCKER_IMAGE)

# Terraform Targets

.PHONY terraform:apply
terraform\:apply:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -chdir=$(TF_STACK_DIR) apply \
	$(TF_PLAN_FILE)

.PHONY terraform:check
terraform\:check:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) fmt -diff -check $(TF_STACK_DIR)

.PHONY terraform:destroy
terraform\:destroy:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -chdir=$(TF_STACK_DIR) plan -destroy $(TF_VARS_FILES) \
	-out=destroy-$(TF_PLAN_FILE) && \
    $(TF_CMD) -chdir=$(TF_STACK_DIR) apply destroy-$(TF_PLAN_FILE)

.PHONY terraform:fmt
terraform\:fmt:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) fmt $(TF_STACK_DIR)

.PHONY terraform:info
terraform\:info:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -version

.PHONY terraform:init
terraform\:init:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -chdir=$(TF_STACK_DIR) init -backend-config=$(TF_BACKEND_FILE)

.PHONY terraform:plan
terraform\:plan:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -chdir=$(TF_STACK_DIR) plan $(TF_VARS_FILES) \
	-out=$(TF_PLAN_FILE)

.PHONY terraform:shell
terraform\:shell:
	$(DOCKER_SHELL_CMD) $(TF_RUN_CMD)

.PHONY terraform:validate
terraform\:validate:
	$(DOCKER_RUN_CMD) $(TF_RUN_CMD) -chdir=$(TF_STACK_DIR) validate
