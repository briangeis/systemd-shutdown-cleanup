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

First, we are going to create the script that will execute on shutdown.
We are not going to worry at this point what actions we ultimately want the
script to perform. For now, our script is just going to contain a single `echo`
statement which outputs a message to the systemd journal.

A common convention is to put scripts like this in `/usr/local/bin/`. Since we
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

When you are done, write out (aka save) the file with `Ctrl`+`O` followed by
`Enter`, then exit nano with `Ctrl`+`X`.

Finally, we need to make the script executable. From the terminal, run:

```
sudo chmod +x /usr/local/bin/shutdown-cleanup.sh
```

And we are done! Our script does not do anything useful right now, but we will
address that in a later step.

## Step Two: Creating the System Service



## Step Three: Verifying Operation



## Step Four: Customize!



## License

GNU General Public License v3.0

## References



