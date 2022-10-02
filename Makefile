# Makefile
#
# https://makefiletutorial.com

# Configuration for Make

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Project Variables

PROJECT_MAINTAINERS	?= "stuart@stuartellis.name"
ENVIRONMENT			?= dev
AWS_ACCOUNT_ID		?= 333594256635
AWS_REGION			?= eu-west-2
DOCKER_REGISTRY		?= $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
TF_STACK			?= app_config
PROJECT_NAME		?= $(shell basename $(shell pwd))
TARGET_CPU_ARCH		?= $(shell uname -m)

# Docker Commands

DOCKER_BUILD_CMD 		:= docker build
DOCKER_SHELL_CMD		:= docker run -it --entrypoint sh
DOCKER_RUN_CMD 			:= docker run
DOCKER_COMPOSE_CMD		:= docker-compose -f $(shell pwd)/docker/compose.yml
SRC_BIND_DIR			:= /src

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
	@echo "Environment: $(ENVIRONMENT)"
	@echo "Maintainers: $(PROJECT_MAINTAINERS)"
	@echo "Docker Registry: $(DOCKER_REGISTRY)"

.PHONY: test
test:
	@echo "Not implemented" 

## Other Targets

include make/infrastructure/terraform.makefile
include make/apps/basin.makefile
