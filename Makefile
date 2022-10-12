# Makefile
#
# https://makefiletutorial.com

# Configuration for Make

SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Project Variables

PROJECT_NAME		?= basin
PROJECT_MAINTAINERS	?= stuart@stuartellis.name
ENVIRONMENT			?= dev
AWS_ACCOUNT_ID		?= 333594256635
AWS_ECR_ROLE		?= arn:aws:iam::333594256635:role/SjeEcrPublish
DOCKER_REGISTRY		?= $(AWS_ACCOUNT_ID).dkr.ecr.eu-west-2.amazonaws.com

TARGET_CPU_ARCH		?= $(shell uname -m)
TARGET_PLATFORM		?= linux/$(TARGET_CPU_ARCH)
TERRAFORM_VERSION	?= $(shell grep 'terraform' ./.tool-versions | cut -d' ' -f2)

# Docker Commands

DOCKER_BUILD_CMD 		:= docker build
DOCKER_SHELL_CMD		:= docker run --rm -it --entrypoint /bin/sh
DOCKER_RUN_CMD 			:= docker run --rm
DOCKER_COMPOSE_CMD		:= docker-compose -f $(shell pwd)/docker/docker-compose.yml
SRC_BIND_DIR			:= /src

# Workspace Path

ifdef LOCAL_WORKSPACE_FOLDER
    HOST_PROJECT_PATH := $(LOCAL_WORKSPACE_FOLDER)
else
	HOST_PROJECT_PATH := $(shell pwd)
endif

# AWS Credentials

ifdef AWS_ACCESS_KEY_ID
    DOCKER_AWS_CREDENTIALS := --env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE)
else
	DOCKER_AWS_CREDENTIALS :=
endif

# Default Target

.DEFAULT_GOAL := info

## Project Targets

.PHONY: clean
clean:
	git clean -fdx

.PHONY: info
info:
	@echo "Project: $(PROJECT_NAME)"
	@echo "Maintainers: $(PROJECT_MAINTAINERS)"
	@echo "Project Path: $(HOST_PROJECT_PATH)"
	@echo "Target Terraform Version: $(TERRAFORM_VERSION)"
	@echo "Target Environment: $(ENVIRONMENT)"
	@echo "Target CPU Architecture: $(TARGET_CPU_ARCH)"
	@echo "Target Docker Platform: $(TARGET_PLATFORM)"
	@echo "Docker Registry: $(DOCKER_REGISTRY)"

## Other Targets

include make/infrastructure/terraform-tools-container.mk
include make/infrastructure/terraform-cli.mk
include make/apps/basin.mk
