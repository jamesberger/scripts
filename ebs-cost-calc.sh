#!/usr/bin/env bash

# Set a few default variable values
PSAID=""

# Get the first command line argument and set it as the PSAID
PSAID=$1

# If there's no first argument, prompt for one
if [ "$PSAID" = "" ]; then
  echo "Please specify a PSAID after the script name, or specify \"all\" for all customers"
fi

# Get a list of the instances for the specified PSAID
DescribeInstanceOutput="aws ec2 describe-instances --filters=Name=tag:PSA_ID,Values=${PSAID}"

# Pretty up the list into something we can use
ListOfInstances=$($DescribeInstanceOutput | grep InstanceId | cut -d\" -f 4 | tr '\n' ',')

# Build an array from the comma separated list of instances
IFS=',' read -r -a InstancesArray <<< $ListOfInstances

# TESTING: Echo the Instance ID value from the first element of the array to test
#echo -e "First instance in the array is ${InstancesArray[0]}\n\n"


# Get the volume IDs for each instance in the array
for InstanceId in "${InstancesArray[@]}"
 do
   # Get a list of volumes for the instance
   DescribeInstanceVolumesOutput="aws ec2 describe-instances --instance-id $InstanceId"
   # Clean up the volumes list into something we can put into an array
   ListOfVolumesForInstance=$($DescribeInstanceVolumesOutput | grep VolumeId | cut -d\" -f 4 | tr '\n' ',')
   # Create an array with each volume for the instance as an element of the array
   IFS=',' read -r -a InstanceVolumesArray <<< $ListOfVolumesForInstance

   # Append the list of volumes from the instance to our global volume array
   for Volume in ${InstanceVolumesArray[@]}
    do
    GlobalVolumesArray+=("$Volume")
    done

  # Testing in loop
  #echo -e "Here is the list of volumes for $InstanceId:"
  #echo $ListOfVolumesForInstance
  #echo -e "\n\n"
done

# Testing to verify we get the name of every volume for all the instances and
# that each element of the array contains only a single volume
#echo -e "Here's a list of all the volumes for every instance matching the PSAID $PSAID: \n"
#for Volume in "${GlobalVolumesArray[@]}"
#  do
#    echo $Volume
#done

# Get the size and type of each volume in the array
for Volume in "${GlobalVolumesArray[@]}"
do
  # Get the volume size and type
  VolumeTypeAndSizeRawOutput="aws ec2 describe-volumes --volume-ids $Volume"
  VolumeTypeAndSizeCleanedOutput=$($VolumeTypeAndSizeRawOutput | egrep 'VolumeType|Size')

  echo $VolumeTypeAndSizeCleanedOutput
done


# 5. For each volume, add size to size counter for the volume type
# E.g., if test401 has 100 GB of GP2 and 500 GB of ST1, the counter values would look like
# gp2: 100
# io2: 0
# i01: 0
# st1: 500
