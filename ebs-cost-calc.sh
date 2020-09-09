#!/usr/bin/env bash

# This script gets a list of AWS instances matching a certain tag value and then
# it gets a list of all the EBS volumes for those instances.
# Then it goes through each volume, gets the volume size and adds it to a global
# sum for the total GB of each EBS volume type (gp2, io1, etc),
# Once there's a global sum for each EBS volume type, it computes the total cost
# for each volume type, and the total cost for all volumes combined.

# If you need to save the output to a text file, uncomment the line below:
#exec >> ebs-cost-calc_output.txt

# Set a few default variable values
PSAID=""
GlobalGp2Size="0"
GlobalIo1Size="0"
GlobalIo2Size="0"
GlobalSt1Size="0"
GlobalSc1Size="0"
GlobalStandardSize="0"

# Price data pulled from https://aws.amazon.com/ebs/pricing/
Gp2CostPerGb="0.10"
Io1CostPerGb="0.125" # This does not include the $0.065 per provisioned IOPS-month
Io2CostPerGb="0.125" # This does not include the $0.065 per provisioned IOPS-month
St1CostPerGb="0.045"
Sc1CostPerGb="0.025"
StandardCostPerGb="0.05" # Standard = magnetic disk.
# The price for magnetic storage can vary from region to region,
# see https://aws.amazon.com/ebs/previous-generation/ for exact pricing.
# We are using the value for us-west-2 here.

# Get the first command line argument and set it as the PSAID
PSAID=$1

# If there's no first argument, prompt for one
if [ "$PSAID" = "" ]; then
  echo "Please specify a PSAID after the script name"
fi

echo -e "\n\nEBS Cost Calculator\n\nGetting a list of all the instances for $PSAID...\n"

# Get a list of the instances for the specified PSAID
DescribeInstanceOutput="aws ec2 describe-instances --filters=Name=tag:PSA_ID,Values=${PSAID}"

# Pretty up the list into something we can use
ListOfInstances=$($DescribeInstanceOutput | grep InstanceId | cut -d\" -f 4 | tr '\n' ',')

# Build an array from the comma separated list of instances
IFS=',' read -r -a InstancesArray <<< $ListOfInstances

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

echo -e "\n\nComputing total cost for each volume type...\n"

# Using Awk here because the Bash shell is horrible at floating point arithmetic

TotalGp2Cost=$(awk -v price=$Gp2CostPerGb -v qty=$GlobalGp2Size 'BEGIN{TotalGp2Cost=(price*qty); print TotalGp2Cost;}')
TotalIo1Cost=$(awk -v price=$Io1CostPerGb -v qty=$GlobalIo1Size 'BEGIN{TotalIo1Cost=(price*qty); print TotalIo1Cost;}')
TotalIo2Cost=$(awk -v price=$Io2CostPerGb -v qty=$GlobalIo2Size 'BEGIN{TotalIo2Cost=(price*qty); print TotalIo2Cost;}')
TotalSt1Cost=$(awk -v price=$St1CostPerGb -v qty=$GlobalSt1Size 'BEGIN{TotalSt1Cost=(price*qty); print TotalSt1Cost;}')
TotalSc1Cost=$(awk -v price=$Sc1CostPerGb -v qty=$GlobalSc1Size 'BEGIN{TotalSc1Cost=(price*qty); print TotalSc1Cost;}')
TotalStandardCost=$(awk -v price=$StandardCostPerGb -v qty=$GlobalStandardSize 'BEGIN{TotalStandardCost=(price*qty); print TotalStandardCost;}')

echo -e "The total cost of all gp2 storage for $PSAID is \$$TotalGp2Cost per month."
echo -e "The total cost of all io1 storage for $PSAID is \$$TotalIo1Cost per month."
echo -e "The total cost of all io2 storage for $PSAID is \$$TotalIo2Cost per month."
echo -e "The total cost of all st1 storage for $PSAID is \$$TotalSt1Cost per month."
echo -e "The total cost of all sc1 storage for $PSAID is \$$TotalSc1Cost per month."
echo -e "The total cost of all magnetic storage for $PSAID is \$$TotalStandardCost per month."

TotalStorageCombinedCost=$(awk "BEGIN {print $TotalGp2Cost+$TotalIo1Cost+$TotalIo2Cost+$TotalSt1Cost+$TotalSc1Cost+$TotalStandardCost; exit}")

echo -e "\nThe combined cost of all storage is: \n \$$TotalStorageCombinedCost per month.\n\n"
