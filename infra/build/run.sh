#!/bin/bash
set -ex

source /opt/build/build_functions.sh

trap cleanup EXIT
cleanup() {
  terraform destroy --auto-approve
}

set +x
setup_credentials "$1"
# TODO: Kinda hacky since we already do this parsing in above function.
declare _ID_RSA_CONTENTS
readonly _ID_RSA_CONTENTS=$(echo -n $1 | jq -r .ID_RSA | base64 --decode)
set -x

declare -r _PROJECT_NAME='machine-setup'
declare -r _GIT_REPO='git@github.com:ScottG489/machine-setup.git'

git clone $_GIT_REPO
cd $_PROJECT_NAME

# TODO: This is a bit hacky. It seems clean enough to copy this file into place where the playbook
# TODO:   is expecting it. However, we should really be passing this in as a separate input to
# TODO:   this build. By doing it this way we are assuming the RSA key to clone the repo is the
# TODO:   same as the one we want to put onto the provisioned machine.
# TODO: Can we actually just copy this from /root? Just need to make sure permissions are right
printf -- "$_ID_RSA_CONTENTS" > files/ssh/id_rsa

tf_apply "infra/tf"

ansible_deploy "infra/tf"
