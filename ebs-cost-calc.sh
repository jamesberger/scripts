#!/usr/bin/env bash

# Set a few default variable values
GlobalGp2Size="0"
GlobalIo1Size="0"
GlobalIo2Size="0"
GlobalSt1Size="0"
GlobalSc1Size="0"
GlobalStandardSize="0"
PSAID=""

# Get the first command line argument and set it as the PSAID
PSAID=$1

# If there's no first argument, prompt for one
if [ "$PSAID" = "" ]; then
  echo "Please specify a PSAID after the script name, or specify \"all\" for all customers"
fi

echo -e "\n\nEBS Cost Calculator\n\nGetting a list of all the instances for $PSAID...\n"

# Get a list of the instances for the specified PSAID
DescribeInstanceOutput="aws ec2 describe-instances --filters=Name=tag:PSA_ID,Values=${PSAID}"

# Pretty up the list into something we can use
ListOfInstances=$($DescribeInstanceOutput | grep InstanceId | cut -d\" -f 4 | tr '\n' ',')

# Build an array from the comma separated list of instances
IFS=',' read -r -a InstancesArray <<< $ListOfInstances

# TESTING: Echo the Instance ID value from the first element of the array to test
#echo -e "First instance in the array is ${InstancesArray[0]}\n\n"

echo -e "\nHere's a list of all the instances I found for the PSAID $PSAID: \n"
for InstanceId in "${InstancesArray[@]}"
 do
   echo $InstanceId
done


echo -e "\n\nGetting a list of all volumes I found for the each of the instances above...\n"

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
echo -e "\nHere's a list of all the volumes for every instance matching the PSAID $PSAID: \n"
for Volume in "${GlobalVolumesArray[@]}"
 do
   echo $Volume
done

# Get the size and type of each volume in the array

echo -e "\n\nGetting size and type for each volume. Computing total size for each volume type...\n"
for Volume in "${GlobalVolumesArray[@]}"
do
  # Get the volume size and type
  VolumeTypeRawOutput="aws ec2 describe-volumes --volume-ids $Volume"
  VolumeType=$($VolumeTypeRawOutput | egrep 'VolumeType' | cut -d'"' -f 4)

  # Check to see what type the volume is, and increment a global variable
  # based on the volume type and size so the global variable matches the
  # combined size of all volumes of that type

  if [[ $VolumeType = "gp2" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalGp2Size=$((GlobalGp2Size + VolumeSize))
  fi

  if [[ $VolumeType = "io1" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalIo1Size=$((GlobalIo1Size + VolumeSize))
  fi

  if [[ $VolumeType = "io2" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalIo2Size=$((GlobalIo2Size + VolumeSize))
  fi

  if [[ $VolumeType = "st1" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalSt1Size=$((GlobalSt1Size + VolumeSize))
  fi

  if [[ $VolumeType = "sc1" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalSc1Size=$((GlobalSc1Size + VolumeSize))
  fi

  if [[ $VolumeType = "standard" ]]; then
    VolumeSize=$($VolumeTypeRawOutput | egrep 'Size' | cut -d' ' -f 14)
    GlobalStandardSize=$((GlobalStandardSize + VolumeSize))
  fi

done

echo -e "The total gp2 volume size is $GlobalGp2Size GB"
echo -e "The total io1 volume size is $GlobalIo1Size GB"
echo -e "The total io2 volume size is $GlobalIo2Size GB"
echo -e "The total st1 volume size is $GlobalSt1Size GB"
echo -e "The total sc1 volume size is $GlobalSc1Size GB"
echo -e "The total magentic volume size is $GlobalStandardSize GB"

echo -e "\n\nComputing total cost for each volume type...\n\n"

# Compute costs here
