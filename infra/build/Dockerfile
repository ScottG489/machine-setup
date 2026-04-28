FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4

ENV HOME="/home/ubuntu"

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git=1:2.53.0-1ubuntu1 \
  ansible=13.1.0+dfsg-1ubuntu1 \
  jq=1.8.1-4ubuntu2 \
  curl=8.18.0-1ubuntu2 \
  unzip=6.0-29ubuntu1

ARG TERRAFORM_VERSION=1.14.9
RUN curl https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip -d /usr/local/bin /tmp/terraform.zip && \
  rm /tmp/terraform.zip

ARG AWSCLI_VERSION=2.34.35
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
