#!/bin/bash
set -ex

source $HOME/build/build_functions.sh

trap cleanup EXIT
cleanup() {
  cd "$(get_git_root_dir)/infra/tf"
  terraform destroy --auto-approve
}

set +x
setup_credentials "$1"
set -x

declare -r _PROJECT_NAME='machine-setup'
declare -r _GIT_REPO='git@github.com:ScottG489/machine-setup.git'
declare -r _RUN_TASK=$(jq -r .RUN_TASK <<< "$1")
declare -r _GIT_BRANCH=$(jq -r .GIT_BRANCH <<< "$1")

[ -d "$_PROJECT_NAME" ] || git clone --branch $_GIT_BRANCH $_GIT_REPO
cd $_PROJECT_NAME

# TODO: This is a bit hacky. It seems clean enough to copy this file into place where the playbook
# TODO:   is expecting it. However, we should really be passing this in as a separate input to
# TODO:   this build. By doing it this way we are assuming the RSA key to clone the repo is the
# TODO:   same as the one we want to put onto the provisioned machine.
cp $HOME/.ssh/id_rsa files/ssh/id_rsa
chmod 644 files/ssh/id_rsa

cp $HOME/.ssh/mainkeypair.pem files/ssh/mainkeypair.pem
chmod 644 files/ssh/mainkeypair.pem

cp $HOME/.aws/credentials files/aws/credentials

tf_apply "infra/tf"

ansible_deploy "infra/tf"

run_tests "infra/tf"
