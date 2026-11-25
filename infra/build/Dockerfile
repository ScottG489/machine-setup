FROM ubuntu:24.04@sha256:562111b88caa79c71391c0c4d3c2114a7d5c35915c20561fd893cb1e07929e6b

ENV HOME="/home/ubuntu"

# Ubuntu packages come from this point-in-time snapshot of the archive instead of
# per-package version pins, which stop building as soon as Ubuntu supersedes a version.
# Renovate bumps it through the ubuntu-snapshot datasource in ScottG489/renovate-config.
ARG UBUNTU_SNAPSHOT=20261120T050039Z
RUN echo "APT::Snapshot \"${UBUNTU_SNAPSHOT}\";" > /etc/apt/apt.conf.d/50snapshot

# snapshot.ubuntu.com is HTTPS-only and the base image has no CA bundle yet, so the
# bootstrap skips TLS peer verification. apt still checks every index and package
# against the Ubuntu archive key, same as the image's default http:// sources.
RUN apt-get -o Acquire::https::Verify-Peer=false update && \
  apt-get -o Acquire::https::Verify-Peer=false install -y --no-install-recommends ca-certificates && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  ansible \
  jq \
  curl \
  unzip

ARG TERRAFORM_VERSION=1.15.8
RUN curl https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip -d /usr/local/bin /tmp/terraform.zip && \
  rm /tmp/terraform.zip

ARG AWSCLI_VERSION=2.42.3
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWSCLI_VERSION.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -rf aws awscliv2.zip

USER ubuntu

RUN mkdir $HOME/.ssh
COPY known_hosts $HOME/.ssh/known_hosts

RUN mkdir $HOME/.aws
COPY config $HOME/.aws/config

RUN mkdir -p $HOME/build
COPY run.sh $HOME/build/run.sh
COPY build_functions.sh $HOME/build/build_functions.sh

WORKDIR $HOME/build
ENTRYPOINT ["./run.sh"]
