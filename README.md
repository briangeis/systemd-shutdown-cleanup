# **systemd-shutdown-cleanup**

Tutorial on how to create a system service to perform shutdown cleanup tasks
on systemd-based Linux distros.

## Overview

Shell scripting languages offer us a powerful tool to create scripts which
automate tasks in a Linux environment. Often, we may want these scripts to
trigger automatically when a system event occurs. Which is why it comes as no
surprise a common question I read online is: *how do I create a cleanup script
that runs on shutdown?*

On systemd-based Linus distros the method to accomplish this task is not
immediately obvious or intuitive if you are not familiar with how systemd
works. The goal of this tutorial is to help you create your own cleanup script
and an accompanying system service which executes it automatically on shutdown.

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

# Output a message to systemd log
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

Finally, we are going to reboot our system to make sure the script executes on
shutdown. After the system has rebooted, we will verify that the system service
successfully executed the script by checking the systemd journal.

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



## License

GNU General Public License v3.0

## References



