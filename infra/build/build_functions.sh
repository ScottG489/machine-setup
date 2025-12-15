#!/bin/bash
set -e

get_git_root_dir() {
  echo -n "$(git rev-parse --show-toplevel)"
}

setup_credentials() {
  set +x
  local ID_RSA_CONTENTS
  local MAINKEYPAIR_CONTENTS
  local AWS_CREDENTIALS_CONTENTS
  readonly ID_RSA_CONTENTS=$(echo -n "$1" | jq -r .ID_RSA | base64 --decode)
  readonly MAINKEYPAIR_CONTENTS=$(echo -n "$1" | jq -r .MAIN_KEY_PAIR | base64 --decode)
  readonly AWS_CREDENTIALS_CONTENTS=$(echo -n "$1" | jq -r .AWS_CREDENTIALS | base64 --decode)
  [[ -n $ID_RSA_CONTENTS ]]
  [[ -n $MAINKEYPAIR_CONTENTS ]]
  [[ -n $AWS_CREDENTIALS_CONTENTS ]]

  printf -- "$ID_RSA_CONTENTS" > $HOME/.ssh/id_rsa
  printf -- "$MAINKEYPAIR_CONTENTS" > $HOME/.ssh/mainkeypair.pem
  printf -- "$AWS_CREDENTIALS_CONTENTS" > $HOME/.aws/credentials

  chmod 400 $HOME/.ssh/id_rsa
  chmod 400 $HOME/.ssh/mainkeypair.pem
}

tf_apply() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly RELATIVE_PATH_TO_TF_DIR=$1

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  terraform init
  terraform plan
  terraform apply --auto-approve
}

ansible_deploy() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR
  local INVENTORY

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly RELATIVE_PATH_TO_TF_DIR=$1

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  readonly INVENTORY=$(terraform show --json | jq --raw-output '.values.root_module.child_modules[].resources[] | select(.address == "module.helpers_spot_instance_ssh.aws_spot_instance_request.spot_instance_request") | .values.public_dns')

  cd "$ROOT_DIR"

  ansible-playbook -v -u ubuntu -e \
  ansible_ssh_private_key_file=$HOME/.ssh/mainkeypair.pem \
  --inventory "$INVENTORY", desktop-master-playbook.yml
  # Run a second time since this playbook should be able to run any number of times against a machine
  ansible-playbook -v -u ubuntu -e \
  ansible_ssh_private_key_file=$HOME/.ssh/mainkeypair.pem \
  --inventory "$INVENTORY", desktop-master-playbook.yml
  # Running the server playbook here only really provides a sanity check since it doesn't run from scratch
  ansible-playbook -v -u ubuntu -e \
  ansible_ssh_private_key_file=$HOME/.ssh/mainkeypair.pem \
  --inventory "$INVENTORY", server-master-playbook.yml
}

run_tests() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR
  local INVENTORY

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly RELATIVE_PATH_TO_TF_DIR=$1

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  readonly INVENTORY=$(terraform show --json | jq --raw-output '.values.root_module.child_modules[].resources[] | select(.address == "aws_spot_instance_request.spot_instance_request") | .values.public_dns')

  cd "$ROOT_DIR"

  ansible-playbook -v -u ubuntu -e ansible_ssh_private_key_file=$HOME/.ssh/mainkeypair.pem --inventory "$INVENTORY", test_playbook/test-playbook.yml
}
