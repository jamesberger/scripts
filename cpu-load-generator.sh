#!/bin/bash

# Sleep a random interval between 1 second and 4 min 50 seconds (290 seconds)
RANDOM_SLEEP_INTERVAL=$(shuf -i 1-290 -n 1)
RANDOM_CPU_LOAD_DURATION=$(shuf -i 2-25 -n 1)


# CPU load generator - gzip the output of dev/urandom and put the output in dev/null for a random duration between 2 and 25 seconds
sleep $RANDOM_SLEEP_INTERVAL; timeout $RANDOM_CPU_LOAD_DURATION cat /dev/urandom | gzip -9 > /dev/null

