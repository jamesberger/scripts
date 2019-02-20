#!/usr/bin/env bash

# Echo commands out as they're being run for debugging purposes, uncomment to use
#set -x

# Date and time the script starts running
date=$(date +%Y-%m-%d_%H-%M)

# A file to store the results in
logfile="instance_check_results_$date"

# A text file with one AWS instance ID per line
instance_id_file='list-of-instances-to-check.txt'

# Array of current AWS regions
regions=(us-east-1 us-east-2 us-west-1 us-west-2 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 ap-south-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 sa-east-1)

# What tag to check
tag='Name'


for element in "${regions[@]}"; do
  echo "Checking region $element..." | tee -a $logfile
  cat $instance_id_file | while read line
    do
      echo "Checking for host $line" | tee -a $logfile
      aws ec2 describe-tags --filters "Name=resource-id,Values=$line" "Name=tag-key,Values=$tag" --region $element | grep Value | tee -a $logfile
    done
  done
