#!/bin/bash

# --------------------------
# Simple Load Test Utility
# --------------------------
# Written by James Berger
# Last updated: August 13th 2013


# Description:
# ------------
# This grabs the five minute load average via the uptime command.
# It compares it to the max_load variable and if the current load
# average is higher than the max_load variable, it alerts and 
# sends you an email.


# Setting our variables
max_load=0.001


# We call uptime, and then we use cut with space delimiters to grab
# the five minute load average, then we use translate (tr) to strip
# out any spaces and commas so we have a nice float value instead
# of a string.
current_load=$(uptime | cut -d' ' -f 15 | tr -d "," | tr -d " ")


echo $current_load
echo $max_load

if [ $(echo "$current_load > $max_load"|bc) -eq 1 ]
then
 echo -e "zomg, high load!"
else
 echo -e "Load is doing alright."
fi
