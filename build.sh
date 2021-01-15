#!/usr/bin/env bash

readonly IMAGE_NAME='scottg489/machine-setup-build:latest'
readonly ID_RSA=$1
readonly AWS_CREDENTIALS=$3
readonly MAIN_KEY_PAIR=$4

read -r -d '' JSON_BODY <<- EOM
  {
  "ID_RSA": "$ID_RSA",
  "AWS_CREDENTIALS": "$AWS_CREDENTIALS",
  "MAIN_KEY_PAIR": "$MAIN_KEY_PAIR",
  }
EOM

curl -v -sS -w '%{http_code}' \
  --data-binary "$JSON_BODY" \
  "http://api.conjob.io/job/run?image=$IMAGE_NAME" \
  | tee /tmp/foo \
  | sed '$d' && \
  [ "$(tail -1 /tmp/foo)" -eq 200 ]
