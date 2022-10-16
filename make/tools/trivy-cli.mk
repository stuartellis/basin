# Makefile for Trivy Security Scanner
#
# https://aquasecurity.github.io/trivy

# Trivy Docker Container

TRIVY_CMD_DOCKER_IMAGE		:= aquasec/trivy:$(TRIVY_VERSION)
TRIVY_CACHE_DIR				:= ./tmp/cache/trivy

# Other Project Variables for Trivy

TRIVY_SRC_HOST_DIR		:= $(HOST_PROJECT_PATH)

TRIVY_RUN_CMD := --user $(shell id -u) \
 	--mount type=bind,source=$(TRIVY_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
 	-w $(SRC_BIND_DIR) \
 	$(TRIVY_CMD_DOCKER_IMAGE) --skip-dirs $(TRIVY_CACHE_DIR) --cache-dir $(TRIVY_CACHE_DIR)

# Trivy Targets

.PHONY trivy-info:
trivy-info:
	@$(DOCKER_RUN_CMD) $(TRIVY_RUN_CMD) --version

.PHONY trivy-code:
trivy-code:
	@$(DOCKER_RUN_CMD) $(TRIVY_RUN_CMD) config .

.PHONY trivy-scan:
trivy-scan:
	@$(DOCKER_RUN_CMD) $(TRIVY_RUN_CMD) fs .

.PHONY trivy-shell:
trivy-shell:
	@$(DOCKER_SHELL_CMD) $(TRIVY_RUN_CMD)
