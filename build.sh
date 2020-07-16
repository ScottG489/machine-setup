curl -v -sS -w '%{http_code}' --data-binary '{"ID_RSA": "'"$1"'", "AWS_CREDENTIALS": "'"$2"'", "MAIN_KEY_PAIR": "'"$3"'"}' 'http://api.simple-ci.com/build?image=scottg489/machine-setup-build:latest' \
  | tee /tmp/foo \
  | sed '$d' && \
  [ "$(tail -1 /tmp/foo)" -eq 200 ]
