# Makefile for Trivy Security Scanner
#
# https://aquasecurity.github.io/trivy

# Trivy Docker Container

TRIVY_CMD_DOCKER_IMAGE		:= aquasec/trivy:$(TRIVY_VERSION)

# Other Project Variables for Trivy

TRIVY_CONFIG_FILE			:= ./trivy.yaml
TRIVY_CACHE_DIR				:= ./tmp/cache/trivy
TRIVY_OUTPUT_DIR			:= ./tmp/output/trivy
TRIVY_OUTPUT_FILE			:= trivy-report.txt
TRIVY_OUTPUT_FORMAT			:= table
TRIVY_SRC_HOST_DIR			:= $(HOST_PROJECT_PATH)

TRIVY_RUN_CMD := --user $(shell id -u) \
 	--mount type=bind,source=$(TRIVY_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
 	-w $(SRC_BIND_DIR) \
 	$(TRIVY_CMD_DOCKER_IMAGE) --cache-dir $(TRIVY_CACHE_DIR) --format $(TRIVY_OUTPUT_FORMAT) --output $(TRIVY_OUTPUT_DIR)/$(TRIVY_OUTPUT_FILE) --config $(TRIVY_CONFIG_FILE)

# Trivy Targets

.PHONY trivy-info:
trivy-info:
	@$(DOCKER_RUN_CMD) $(TRIVY_RUN_CMD) --version

.PHONY trivy-code:
trivy-code:
	@mkdir -p $(TRIVY_CACHE_DIR)
	@mkdir -p $(TRIVY_OUTPUT_DIR)
	@$(DOCKER_RUN_CMD) $(TRIVY_RUN_CMD) config .

.PHONY trivy-shell:
trivy-shell:
	@$(DOCKER_SHELL_CMD) $(TRIVY_RUN_CMD)
