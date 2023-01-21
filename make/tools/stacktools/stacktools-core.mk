# Stack Tools - Core Commands
#
# Makefile targets and variables
#
# Requirements: A UNIX shell, jq, GNU Make 3 or above
#

###### Versions ######

ST_STACKTOOLS_VERSION		:= 0.4.15
ST_STACKTOOLS_REPO_URL		:= git@gitlab.com:stuartellis-org/stacktools.git
ST_STACKTOOLS_REPO_BRANCH	:= main
ST_STACKTOOLS_PKG			:= stacktools-DELETE-ME.tar

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
	@git archive --remote $(ST_STACKTOOLS_REPO_URL) --format tar --output $(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_REPO_BRANCH)
	@tar -xzf $(ST_STACKTOOLS_PKG) docker/tools/stacktools make/tools/stacktools
	@make stacks-new-tree ST_ENABLE_BACKEND=false
	@rm $(ST_STACKTOOLS_PKG)
	@make stacktools-info

.PHONY: stacktools-update
stacktools-update:
	@git archive --remote $(ST_STACKTOOLS_REPO_URL) --format tar --output $(ST_STACKTOOLS_PKG) $(ST_STACKTOOLS_REPO_BRANCH)
	@tar -xzf $(ST_STACKTOOLS_PKG) docker/tools/stacktools make/tools/stacktools
	@rm $(ST_STACKTOOLS_PKG)
