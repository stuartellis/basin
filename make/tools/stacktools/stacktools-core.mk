# Stack Tools - Terraform Commands
#
# Makefile targets and variables
#
# Requirements: A UNIX shell, jq, GNU Make 3 or above
#
#
# This provides the Terraform variables: stack_name, environment, variant
#

###### Versions ######

ST_STACKTOOLS_VERSION	:= 0.4.14
ST_STACKS_SPEC_VERSION	:= 0.4.0
ST_STACKS_SPEC_URL		:= https://gitlab.com/stuartellis-org/stacktools/-/tree/main/docs/terraform-stacks-spec/$(ST_STACKS_SPEC_VERSION)/README.md

###### Docker Image ######

STACK_RUNNER_IMAGE		?= stacktools-runner:developer

.PHONY: stacktools-info
stacktools-info:
	@echo "Stack Tools Version: $(ST_STACKTOOLS_VERSION)"
	@echo "Stacks Specification Version: $(ST_STACKS_SPEC_VERSION)"
	@echo "Stacks Specification URL: $(ST_STACKS_SPEC_URL)"

.PHONY: stacktools-update
stacktools-update:
	@git archive --remote git@gitlab.com:stuartellis-org/stacktools.git --format tar --output stacktools.tar main
	@tar -xvzf stacktools.tar docker/tools/stacktools make/tools/stacktools
	@rm stacktools.tar
