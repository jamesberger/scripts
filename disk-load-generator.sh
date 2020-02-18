#!/bin/bash

# Sleep a random interval between 1 second and 4 min 50 seconds (290 seconds)
RANDOM_SLEEP_INTERVAL=$(shuf -i 1-290 -n 1)
RANDOM_DISK_FILE_SIZE_COUNT=$(shuf -i 128-4096 -n 1)
                                                                                                                                                                                         
# Disk utilization generator                                                                                                                                                             
if test -f "/root/disk-load-file"; then                                                                                                                                                  
  rm -f /root/disk-load-file                                                                                                                                                             
fi                                                                                                                                                                                       
dd if=/dev/zero of=/root/disk-load-file bs=1M count=$RANDOM_DISK_FILE_SIZE_COUNT; sleep $RANDOM_SLEEP_INTERVAL; rm -f /root/disk-load-file    
