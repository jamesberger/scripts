#!/usr/bin/env bash

# Echo commands out as they're being run for debugging purposes, uncomment to use
# set -x

# A text file with one AWS instance ID per line
instance_id_file='instance-ids.txt'

# An array of the current AWS regions, update as needed
regions=(us-east-1 us-east-2 us-west-1 us-west-2 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 ap-south-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 sa-east-1)

# Tag value to check
tag='Role'

for element in "${regions[@]}"; do
  echo "Checking region $element..."
  cat $instance_id_file | while read line
    do
      aws ec2 describe-tags --filters "Name=resource-id,Values=$line" "Name=tag-key,Values=$tag" --region $element | grep Value
    done
done
