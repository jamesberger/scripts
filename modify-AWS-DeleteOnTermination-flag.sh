#!/usr/bin/env bash

# A simple Bash script to modify the DeleteOnTermination flag on AWS instances.
# In this case, it is set to modify the root EBS volume for the instance, but
# the syntax of the command can be modifed as needed to target the desired volume

# An array with a space separated list of instances
# This only has three example instance Ids listed but will work with much larger
# numbers of instances
instances=(i-1234567891011121 i-31415161718192021 i-22232425262728293)

# This runs the aws ec2 modify-instance-attribute command on every instance in
# the array and updates the DeleteOnTermination flag on the root EBS volume to
# false (Normally set to true so you don't have a ton of EBS volumes laying
# around after you terminate a few instances)
for i in ${instances[@]};
  do
     aws ec2 modify-instance-attribute --instance-id $i --block-device-mappings "[{\"DeviceName\": \"/dev/xvda\",\"Ebs\":{\"DeleteOnTermination\":false}}]"
done
