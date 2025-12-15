FROM ubuntu:24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54

ENV HOME="/home/ubuntu"

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  ansible \
  jq \
  curl \
  unzip

RUN curl https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip -d /usr/local/bin /tmp/terraform.zip && \
  rm /tmp/terraform.zip

RUN mkdir /tmp/awscli && \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
  unzip -d /tmp/awscli /tmp/awscliv2.zip && \
  /tmp/awscli/aws/install

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
