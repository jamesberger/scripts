#!/bin/bash                                                                                                                                                                              
                                                                                                                                                                                         
# Sleep a random interval between 1 second and 4 min 50 seconds (290 seconds)                                                                                                            
RANDOM_SLEEP_INTERVAL=$(shuf -i 1-290 -n 1)                                                                                                                                              
RANDOM_MEMORY_FILE_SIZE_COUNT=$(shuf -i 128-512 -n 1)                                                                                                                                    
# Verify that our ram drive exists, if it doesn't, create it                                                                                                                             
# If it does exist, create a file in the ram drive of a random size, sleep for a variable time, then delete it                                                                           
                                                                                                                                                                                         
if test -f "/root/ram-drive/random-data"; then                                                                                                                                           
  rm -f /root/ram-drive/random-data                                                                                                                                                      
fi                                                                                                                                                                                       
                                                                                                                                                                                         
if mountpoint -q /root/ram-drive/                                                                                                                                                        
then                                                                                                                                                                                     
  dd if=/dev/zero of=/root/ram-drive/random-data bs=1M count=$RANDOM_MEMORY_FILE_SIZE_COUNT
  sleep $RANDOM_SLEEP_INTERVAL
  rm -f /root/ram-drive/random-data
else
  echo "Ram drive not mounted, creating ram drive mount"
  mount -t tmpfs -o size=512M tmpfs /root/ram-drive/
  dd if=/dev/zero of=/root/ram-drive/random-data bs=1M count=$RANDOM_MEMORY_FILE_SIZE_COUNT
  sleep $RANDOM_SLEEP_INTERVAL
  rm -f /root/ram-drive/random-data
fi

