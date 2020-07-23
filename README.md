# Machine setup
![CI](https://github.com/ScottG489/machine-setup/workflows/CI/badge.svg)

This can be run locally on an existing machine by running the following:
```bash
ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 master-playbook.yml
```
Be sure to change the playbook to the one appropriate for the host system you're running it on

Also be sure to put the proper RSA key at `files/ssh/id_rsa`. This is the RSA key which will be put onto the provisioned machine. It's needed to clone github repos such as the dotfile repo.

After run login to machine as the user 'vagrant' with the default password of 'vagrant'. Then `sudo su` to log in as root and run `passwd scott` to create the password for the user 'scott'. Then log out of root and vagrant and log in with scott using the new password.

After logging in run `startx` to start the X Window System.

If there are issues with setting the resolution properly then make sure the proper VirtualBox guest additions are installed on the guest. Note that this isn't necessary if running on a mac as parallels should be used.

On Windows, you'll need to shut down the machine and adjust 2 things under the 'Display' settings for the VM.
1. Increase the 'Video Memory' (I increased it to 32 MB)
2. Change the 'Graphics Controller' to 'VMSVGA'

Start up the VM, then you'll need to set the resolution under the View menu dropdown. This should stick across reboots. It's possible something may also need to be done with `xrandr` as well, but I didn't have to this time.

## Development
Here is an example of developing the build in conjunction with the application locally.
Make sure you change the file locations of the desired secrets to your actual location.

```bash
ID_RSA_CONTENTS_BASE64=$(base64 ~/.ssh/id_rsa | tr -d '\n') ;
AWS_CREDENTIALS_CONTENTS_BASE64=$(base64 ~/.aws/credentials | tr -d '\n') ;
MAINKEYPAIR_CONTENTS_BASE64=$(base64 ~/.ssh/mainkeypair.pem | tr -d '\n') ;
docker build infra/build -t machine-setup-test && \
docker run -it --volume "$PWD:/opt/build/machine-setup" machine-setup-test '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "AWS_CREDENTIALS": "'"$AWS_CREDENTIALS_CONTENTS_BASE64"'", "MAIN_KEY_PAIR": "'"$MAINKEYPAIR_CONTENTS_BASE64"'"}'
```

1. Initialize the secrets as envars (these will be passed in as the arguments to the container)
2. Build the image locally
3. Run the image with the path to your local repository mounted where the code would normally be cloned to

Note that you'll need to comment out the `git clone` in the build otherwise it will fail since you've mounted a directory there

## Misc
### Reset Intellij Ultimate trial
```bash
rm -rf .java/.userPrefs .config/JetBrains/IntelliJIdea2020.1/options/other.xml .config/JetBrains/IntelliJIdea2020.1/eval/*
```
See also: https://dstarod.github.io/idea-trial/
