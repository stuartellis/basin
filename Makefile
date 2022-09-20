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

.DEFAULT_GOAL := test

## Project Targets

.PHONY: clean
clean:
	git clean -fdx

.PHONY: test
test:
	@echo "Not implemented" 

## Other Targets

include make/infrastructure/terraform.makefile
include make/apps/basin.makefile
