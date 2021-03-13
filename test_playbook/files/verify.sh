#!/bin/bash
set -x

FAILURES=0
trap 'FAILURES=$((FAILURES+1))' ERR

test_timezone() {
  [[ "$(date +'%Z')" =~ P(S|D)T ]]
}

test_clone() {
  mkdir -p "$HOME"/code
  cd "$HOME"/code || return 1
  git clone git@github.com:ScottG489/dotfiles.git
  rm -rf dotfiles
}

test_aws_region() {
  [ "$(aws ec2 describe-availability-zones \
    --output text \
    --query 'AvailabilityZones[0].[RegionName]')" \
    = 'us-west-2' ]
}

test_google_chrome_installed() {
  [ -x "$(command -v google-chrome)" ]
}

test_clone
test_timezone
test_aws_region
test_google_chrome_installed

if ((FAILURES == 0)); then
  echo "Test status: SUCCESS"
else
  echo "Test status: FAIL"
  echo "Number of FAILURES: $FAILURES"
  exit 1
fi
