curl -v -s -f --data-binary '{"ID_RSA": "'"$1"'", "AWS_CREDENTIALS": "'"$2"'", "MAIN_KEY_PAIR": "'"$3"'"}' 'http://simple-ci.com:8080/build?image=scottg489/machine-setup-build:latest'
