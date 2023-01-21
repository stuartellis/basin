# Stack Tools - Core Commands
#
# Makefile targets and variables
#

###### Versions ######

ST_STACKTOOLS_VERSION		:= 0.4.16
ST_STACKTOOLS_REPO_URL		:= git@gitlab.com:stuartellis-org/stacktools.git
ST_STACKTOOLS_REPO_BRANCH	:= main
ST_STACKTOOLS_PKG			:= stacktools-DELETE-ME.tar
ST_STACKTOOLS_SRC_DIR		:= src
ST_STACKTOOLS_TMP_DIR		:= .stacktools

ST_STACKS_SPEC_VERSION		:= 0.4.0
ST_STACKS_SPEC_URL			:= https://gitlab.com/stuartellis-org/stacktools/-/tree/main/docs/terraform-stacks-spec/$(ST_STACKS_SPEC_VERSION)/README.md

###### Docker Image ######

STACK_TOOLS_RUNNER_IMAGE	?= stacktools-runner:developer

###### Targets ######

.PHONY: stacktools-info
stacktools-info:
	@echo "Stack Tools Version: $(ST_STACKTOOLS_VERSION)"
	@echo "Stacks Specification Version: $(ST_STACKS_SPEC_VERSION)"
	@echo "Stacks Specification URL: $(ST_STACKS_SPEC_URL)"

.PHONY: stacktools-init
stacktools-init:
	@mkdir -p $(ST_STACKTOOLS_TMP_DIR)
	@git archive --remote $(ST_STACKTOOLS_REPO_URL) --format tar --output $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_REPO_BRANCH)
	@tar -C .stacktools -xzf $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_SRC_DIR)/docker/tools/stacktools $(ST_STACKTOOLS_SRC_DIR)/make/tools/stacktools $(ST_STACKTOOLS_SRC_DIR)/terraform1
	@mkdir -p $(PROJECT_DIR)/docker/tools $(PROJECT_DIR)/make/tools
	@cp -R $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_SRC_DIR)/terraform1 $(PROJECT_DIR)
	@cp -R $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_SRC_DIR)/docker/tools/stacktools $(PROJECT_DIR)/docker/tools
	@cp -R $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_SRC_DIR)/make/tools/stacktools $(PROJECT_DIR)/make/tools
	@rm -r $(ST_STACKTOOLS_TMP_DIR)
	@make stacktools-info

.PHONY: stacktools-update
stacktools-update:
	@mkdir -p $(ST_STACKTOOLS_TMP_DIR)
	@git archive --remote $(ST_STACKTOOLS_REPO_URL) --format tar --output $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_REPO_BRANCH)
	@tar -C .stacktools -xzf $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_SRC_DIR)/docker/tools/stacktools $(ST_STACKTOOLS_SRC_DIR)/make/tools/stacktools
	@mkdir -p $(PROJECT_DIR)/docker/tools $(PROJECT_DIR)/make/tools
	@cp -R $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_SRC_DIR)/docker/tools/stacktools $(PROJECT_DIR)/docker/tools
	@cp -R $(ST_STACKTOOLS_TMP_DIR)/$(ST_STACKTOOLS_SRC_DIR)/make/tools/stacktools $(PROJECT_DIR)/make/tools
	@rm -r $(ST_STACKTOOLS_TMP_DIR)
	@make stacktools-info
