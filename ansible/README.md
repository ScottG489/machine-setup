After run login to machine as the user 'vagrant' with the default password of 'vagrant'. Then 'sudo su' to log in as root and run 'passwd scott' to create the password for the user 'scott'. Then log out of root and vagrant and log in with scott using the new password.

After logging in run 'startx' to start the X window server.

If there are issues with setting the resolution properly, make sure that the proper virtualbox guest additions are installed on the guest. Note that this isn't necessary if running on a mac as parallels should be used.
