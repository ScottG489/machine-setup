# Machine setup
![CI](https://github.com/ScottG489/machine-setup/workflows/CI/badge.svg)

This can be run locally on an existing machine by running the following:
```bash
ansible-playbook --ask-become-pass --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 desktop-master-playbook.yml
```
Or to run it on a remote machine, something like this:
```shell
ansible-playbook --ask-pass --ask-become-pass --extra-vars 'haos_vm_memory_mb=3072' --inventory 1.2.3.123, home-assistant-server-master-playbook.yml
```
Be sure to change the playbook to the one appropriate for the host system you're running it on.

Also be sure to put the proper RSA key at `files/ssh/id_rsa`. This is the RSA key which will be put onto the provisioned machine. It's needed to clone github repos such as the dotfile repo.

After run login to machine as the user 'vagrant' with the default password of 'vagrant'. Then `sudo su` to log in as root and run `passwd scott` to create the password for the user 'scott'. Then log out of root and vagrant and log in with scott using the new password.

After logging in run `startx` to start the X Window System.

If there are issues with setting the resolution properly then make sure the proper VirtualBox guest additions are
installed on the guest. Note that this isn't necessary if running on a mac as parallels should be used.
To use parallels ensure the plugin is installed before bringing up the VM:
```shell
vagrant plugin install vagrant-parallels
```
You also need a properly licensed version of parallels and may need to specify `--provider=parallels` on the command
line if you have other providers installed (e.g. vbox).

On Windows, you'll need to shut down the machine and adjust 2 things under the 'Display' settings for the VM.
1. Increase the 'Video Memory' (I increased it to 32 MB)
2. Change the 'Graphics Controller' to 'VMSVGA'

Start up the VM, then you'll need to set the resolution under the View menu dropdown. This should stick across reboots. It's possible something may also need to be done with `xrandr` as well, but I didn't have to this time.

## Ubuntu USB auto-installer
This will create a USB flash drive that will auto install an Ubuntu system.

First, copy `autoinstall-user-data-example.yaml` to `autoinstall-user-data.yaml` and modify it accordingly.
Then generate the auto-installer ISO:
```shell
git clone git@github.com:covertsh/ubuntu-autoinstall-generator.git && cd ubuntu-autoinstall-generator
wget http://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso
./ubuntu-autoinstall-generator.sh -a -k -u ../autoinstall-user-data.yaml -s ./ubuntu-20.04.3-live-server-amd64.iso -d ubuntu-autoinstall.iso
```
Then write it to a flash drive (e.g. /dev/sdc) using `sudo dd if=ubuntu-autoinstall.iso of=/dev/sdx`.
Make sure to change the above device path and **always triple check you're writing to the correct device**.

More info on autoinstall can be found here:
https://ubuntu.com/server/docs/install/autoinstall

## Development
To fully test your changes run `./test.sh` at the root of the project. However, first make sure to change
the file locations of the secrets to your actual locations.

You can also test locally using something like the following:
```shell
vagrant provision desktop --provision-with test
```

Note that you'll need to comment out the `git clone` in `run.sh` otherwise it will fail since you've mounted a directory where it will attempt to clone to.

### Tips
Commenting out lines can speed up your local development. Just be sure not to check in these changes! A few examples of doing this are:
- Commenting out the line to tear down the environment after it's finished running. This can help with turnaround time since you won't have to recreate the environment every time. However, still be aware you could miss problems by not running the suite from scratch. So be careful doing this. Also, be sure to tear down the environment after you're finished with it so there aren't dangling unused instances.
- Commenting out anything which you don't need to run every time. For instance not running `terraform apply` subsequent times if you are only working on the playbooks could save time.

## Misc
### Reset Intellij Ultimate trial
Make sure you're on a version < `2021.2.3`. This installs the latest version before than on Ubuntu:
```shell
sudo snap refresh --channel 2021.1/stable intellij-idea-ultimate --classic
```
See [this JetBrains blog post](https://blog.jetbrains.com/blog/2021/09/30/moving-to-jetbrains-account-for-trials-of-ides-and-net-tools/)
for more details.

Then run this to reset the trial.
```bash
rm -rf ~/.java/.userPrefs ~/.config/JetBrains/*/options/other.xml ~/.config/JetBrains/*/eval/*
```
See also: https://dstarod.github.io/idea-trial/
