# **systemd-shutdown-cleanup**

Tutorial on how to create a shutdown cleanup system service on
systemd-based Linux distros.

## Table of Contents

* [Overview](#overview)
* [Step One: Creating the Script](#step-one-creating-the-script)
* [Step Two: Creating the System Service](#step-two-creating-the-system-service)
* [Step Three: Verifying Operation](#step-three-verifying-operation)
* [Step Four: Customize!](#step-four-customize)
* [License](#license)
* [References](#references)

## Overview

Shell scripting languages offer us a powerful tool to create scripts which
automate tasks in a Linux environment. Often, we may want these scripts to
trigger automatically when a system event occurs. Which is why it comes as no
surprise a common question I read online is: *how do I create a cleanup script
that runs on shutdown?*

On systemd-based Linux distros the method to accomplish this task is not
immediately obvious or intuitive if you are not familiar with how systemd
works. The goal of this tutorial is to help you create your own cleanup script
with an accompanying system service to execute it automatically on shutdown.

## Step One: Creating the Script

### Create the script

First, we are going to create the script that will execute on shutdown.
We are not going to worry at this point what actions we ultimately want the
script to perform. For now, our script is just going to contain a single `echo`
statement which outputs a message to the systemd journal.

A common convention is to put scripts like this in `/usr/local/bin`. Since we
require root permissions to write to this directory, we are going to use `nano`
to create the file. From the terminal, run:

```
sudo nano /usr/local/bin/shutdown-cleanup.sh
```

While in nano, enter the following script:

```bash
#!/bin/bash

# Output a message to systemd journal
echo Performing system cleanup...
```

Write out (aka save) the file with `Ctrl`+`O` followed by `Enter`,
then exit nano with `Ctrl`+`X`.

### Make the script executable

Finally, we need to make the script executable. From the terminal, run:

```
sudo chmod +x /usr/local/bin/shutdown-cleanup.sh
```

And we are done! Our script does not do anything useful right now, but we will
address that in a later step.

## Step Two: Creating the System Service

### Create the service

Now we are going to create the system service to execute our script on
shutdown. This service **must** be placed in `/etc/systemd/system`. As before,
we require root permissions to write to this directory, so we are going to use
`nano` to create the file. From the terminal, run:

```
sudo nano /etc/systemd/system/shutdown-cleanup.service
```

While in nano, enter the following:

```desktop
[Unit]
Description=Shutdown Cleanup Service
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/shutdown-cleanup.sh
RemainAfterExit=true

[Install]
WantedBy=shutdown.target
```

Write out (aka save) the file with `Ctrl`+`O` followed by `Enter`,
then exit nano with `Ctrl`+`X`.

### Enable the service

Next, we need to reload the systemd manager configuration to make it aware of
our new system service. From the terminal, run:

```
sudo systemctl daemon-reload
```

Finally, we need to enable our new system service:

```
sudo systemctl enable shutdown-cleanup
```

And now both our shutdown cleanup script and system service are complete!
Before we move on to creating a useful shutdown cleanup script, we will first
verify everything is working properly.

## Step Three: Verifying Operation

### Verify the script

Verify the script works correctly by running it from the terminal:

```
/usr/local/bin/shutdown-cleanup.sh
```

You should see the output from our `echo` statement:

```
Performing system cleanup...
```

### Verify the system service status

Next, show the runtime status information of our system service:

```
systemctl status shutdown-cleanup.service
```

You should see the following output:

```
○ shutdown-cleanup.service - Shutdown Cleanup Service
     Loaded: loaded (/etc/systemd/system/shutdown-cleanup.service; enabled; preset: disabled)
     Active: inactive (dead)
```

### Verify proper operation

Finally, we are going to reboot our system to make sure everything works as
expected. After the system has rebooted, we will verify successful execution
of the script by checking the systemd journal.

Once you have rebooted your system, from the terminal run:

```
journalctl -u shutdown-cleanup
```

You should see output similar to the following:

```
May 17 14:20:17 hostname systemd[1]: Starting Shutdown Cleanup Service...
May 17 14:20:17 hostname shutdown-cleanup.sh[3168]: Performing system cleanup...
May 17 14:20:17 hostname systemd[1]: Finished Shutdown Cleanup Service.
```

Now that we have verified everything works correctly, we are finally ready to
make our script useful!

## Step Four: Customize!

Now it is time to add functionality to your shutdown script. What you need or
want your script to do is ultimately up to you. However, when creating your
script there are a few things you should keep in mind:

* **Use absolute paths when referencing your home directory.**\
When your script is executed during shutdown, you will be logged out as a user.
This means that both the environment variable `$HOME` and tilde expansion `~/`
*will not* reference your home directory.

* **Avoid using commands which could require user interaction.**\
If a command in your script could encounter a scenario where it would require
user input to proceed, you risk creating a situation where a shutdown or reboot
will hang. Setting appropriate options for commands or adding script logic can
avoid this.

* **Suppress unwanted output to the systemd journal with `/dev/null`.**\
Commands often provide useful output when run. However, you may wish to
suppress this output in your shutdown script to keep the systemd journal free
from clutter. You can accomplish this by redirecting output to `/dev/null`.

Here is a example script to illustrate these points:

```bash
#!/bin/bash

# Output a message to systemd journal
echo Performing system cleanup...

# Creating a variable of the absolute path to the home directory
# as $HOME and ~/ will not work. Replace 'user' with your username.
HOMEDIR=/home/user

# Using the $HOMEDIR variable to backup the script and service we
# created in this tutorial to the Documents folder in our home directory.
cp --force /usr/local/bin/shutdown-cleanup.sh $HOMEDIR/Documents/
cp --force /etc/systemd/system/shutdown-cleanup.service $HOMEDIR/Documents/

# Deleting the thumbnail cache. Note how we are using the --force option
# for both the above cp command and this rm command. This will ensure the
# commands execute without ever prompting the user.
rm --recursive --force $HOMEDIR/.cache/thumbnails/*

# Suppress unwanted output to the systemd journal by directing it to
# /dev/null. By adding the '>/dev/null' to the end of this command, the
# output from this echo statement will not appear in the journal.
echo Suppress the output from this command! >/dev/null
```

## License

GNU General Public License v3.0

## References

[freedesktop.org - systemd Service Unit Configuration](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)

[Red Hat Documentation - Managing Services with systemd](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-managing_services_with_systemd)
