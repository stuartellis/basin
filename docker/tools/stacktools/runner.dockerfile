ARG DOCKER_IMAGE_BASE=alpine:3.17.1
ARG TERRAFORM_VERSION=1.3.7

#============ BASE ===========

FROM ${DOCKER_IMAGE_BASE} as base

RUN apk update && \
    apk upgrade && \
    apk add --no-cache git && \
    apk add --no-cache jq && \
    apk add --no-cache make

#========== BUILDER ==========

FROM base AS builder

ARG TERRAFORM_VERSION
ARG TARGETARCH

RUN apk add --no-cache curl

WORKDIR /usr/local/bin

RUN curl -L https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform\_$TERRAFORM_VERSION\_linux\_$TARGETARCH.zip -o terraform\_$TERRAFORM_VERSION\_linux\_$TARGETARCH.zip && \
    unzip terraform\_$TERRAFORM_VERSION\_linux\_$TARGETARCH.zip && \
    rm terraform\_$TERRAFORM_VERSION\_linux\_$TARGETARCH.zip

#=========== APP ============

FROM base AS app

RUN addgroup appusers \
  && adduser -s /bin/sh -D -H appuser appusers

COPY --from=builder --chown=appuser:appusers /usr/local/bin /usr/local/bin
WORKDIR /usr/local/bin
USER appuser
CMD ["terraform", "version"]
