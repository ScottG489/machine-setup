FROM ubuntu:24.04@sha256:cd1dba651b3080c3686ecf4e3c4220f026b521fb76978881737d24f200828b2b

ENV HOME="/home/ubuntu"

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git=1:2.43.0-1ubuntu7.3 \
  ansible=9.2.0+dfsg-0ubuntu5 \
  jq=1.7.1-3ubuntu0.24.04.1 \
  curl=8.5.0-2ubuntu10.6 \
  unzip=6.0-28ubuntu4.1

ARG TERRAFORM_VERSION=1.14.3
RUN curl https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip -d /usr/local/bin /tmp/terraform.zip && \
  rm /tmp/terraform.zip

ARG AWSCLI_VERSION=2.33.3
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
