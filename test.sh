#!/bin/bash
set -ex

declare ID_RSA_CONTENTS_BASE64
declare AWS_CREDENTIALS_CONTENTS_BASE64
declare MAINKEYPAIR_CONTENTS_BASE64
# Change the location of these files based on where they are on your system
set +x
ID_RSA_CONTENTS_BASE64=$(base64 ~/.ssh/id_rsa | tr -d '\n') ;
AWS_CREDENTIALS_CONTENTS_BASE64=$(base64 ~/.aws/credentials | tr -d '\n') ;
MAINKEYPAIR_CONTENTS_BASE64=$(base64 ~/.ssh/mainkeypair.pem | tr -d '\n') ;
[[ -n $ID_RSA_CONTENTS_BASE64 ]]
[[ -n $AWS_CREDENTIALS_CONTENTS_BASE64 ]]
[[ -n $MAINKEYPAIR_CONTENTS_BASE64 ]]
set -x

docker build infra/build -t machine-setup-test && \
docker run -it \
  --volume "$PWD:/home/ubuntu/build/machine-setup" \
  machine-setup-test \
  '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "AWS_CREDENTIALS": "'"$AWS_CREDENTIALS_CONTENTS_BASE64"'", "MAIN_KEY_PAIR": "'"$MAINKEYPAIR_CONTENTS_BASE64"'"}'
