#!/bin/bash
set -x

FAILURES=0
trap 'FAILURES=$((FAILURES+1))' ERR

test_date() {
  [ "$(date +'%Z')" = 'PDT' ]
}

test_clone() {
  mkdir -p "$HOME"/code
  cd "$HOME"/code || return 1
  git clone git@github.com:ScottG489/dotfiles.git
}

test_clone
test_date

if ((FAILURES == 0)); then
  echo "Test status: SUCCESS"
else
  echo "Test status: FAIL"
  echo "Number of FAILURES: $FAILURES"
  exit 1
fi