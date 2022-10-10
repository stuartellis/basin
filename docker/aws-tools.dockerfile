ARG DOCKER_IMAGE_BASE=amazon/aws-cli:2.8.2

#============ BASE ===========

FROM ${DOCKER_IMAGE_BASE} as base

RUN yum update -y

RUN amazon-linux-extras install -y docker
