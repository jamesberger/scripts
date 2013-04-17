#!/bin/bash
# 
# #######################
# ## Domain to Country ##
# #######################
#
# Description:
# ---------------------------------------------------------
# This is a simple bash script that will output the country 
# for a given domain name in a file based on the contents of
# the input file that it's been given.
#
# What this script is for:
# ---------------------------------------------------------
# Use this script if you want to get a list of what country
# a given domain is coming from.
#
# Author:
# ---------------------------------------------------------
# Written by James Berger
# Last updated: April 17th 2013
#



# This will grab the first argument that's used when executing our script 
# and parse it in as the file to read our domains in from.
domain_input_file=$1

# This will grab the second argument that's used when executing our script 
# and parse it in as the file to put the results in.
domain_output_file=$2


# Here we'll verify that the specified input file is actually
# a valid text file

# The command 'file' returns the file type, so we can verify if it's a text
# file without needed to worry about the file extension.
file_type=file$1

# Here's our if statement for exiting the script if the input file doesn't
# appear to be a valid text file
if [ $file_type="ASCII text" ]; then
 #do stuff to it
elif [ $file_type!="ASCII text" ]; then
 echo "The input file you specified appears to be something other than a text file, this script requires an ASCII text input file to work."
 exit 1
fi

echo "Our file type is:"$file_type


# this is an example of case usage from the init script for ntp
#case $1 in
#        start)
#                log_daemon_msg "Starting NTP server" "ntpd"
#                if [ -z "$UGID" ]; then
#                        log_failure_msg "user \"$RUNASUSER\" does not exist"
#                        exit 1
#                fi
#                lock_ntpdate
#                start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --startas $DAEMON -- -p $PIDFILE $NTPD_OPTS
#                status=$?
#                unlock_ntpdate
#                log_end_msg $status
#                ;;
#        stop)
#                log_daemon_msg "Stopping NTP server" "ntpd"
#                start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
#                log_end_msg $?
#                rm -f $PIDFILE
#                ;;
#        restart|force-reload)
#                $0 stop && sleep 2 && $0 start
#                ;;
#        try-restart)
#                if $0 status >/dev/null; then
#                        $0 restart
#                else
#                        exit 0
#                fi
#                ;;
#        reload)
#                exit 3
#                ;;
#        status)
#                status_of_proc $DAEMON "NTP server"
#                ;;
#        *)
#                echo "Usage: $0 {start|stop|restart|try-restart|force-reload|status}"
#                exit 2
#                ;;
#esac







# Below is an example comand that has the functionality we want from this script, just not in batch-friendly format
# dig +short baidu.com | head -n 1 | xargs whois | grep -i country | head -n 1 | cut -d' ' -f 9
