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
