#!/bin/bash

selectedfiles=("$@")

# open the terminal and run the command as root  (gnome terminal)
gnome-terminal -x bash -c "sudo gedit ${selectedfiles[*]}"