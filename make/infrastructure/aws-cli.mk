# Makefile for AWS CLI
#
# https://makefiletutorial.com

# AWS CLI Docker Container

AWSCLI_CMD_DOCKER_IMAGE		:= aws-tools:developer

# Other Project Variables for AWS CLI

AWSCLI_SRC_HOST_DIR		:= $(HOST_PROJECT_PATH)

AWSCLI_RUN_CMD 			:= --user $(shell id -u) \
 	--mount type=bind,source=$(AWSCLI_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
 	-w $(SRC_BIND_DIR) \
 	$(AWSCLI_CMD_DOCKER_IMAGE)

# AWS CLI Targets

.PHONY aws:shell
aws\:shell:
	@$(DOCKER_SHELL_CMD) $(AWSCLI_RUN_CMD)

.PHONY ecr:creds
ecr\:creds:
	$(DOCKER_RUN_CMD) $(AWSCLI_RUN_CMD) sts assume-role --role-arn $(AWS_ECR_ROLE) --role-session-name=test --region $(AWS_REGION) --output json
