#!/bin/bash
 
# #######################
# ## Domain to Country ##
# #######################


# ---------------------------------------------------------
# Description:
# ---------------------------------------------------------
# This is a simple bash script that will output the country 
# for a given domain name in a file based on the contents of
# the input file that it's been given.


# ---------------------------------------------------------
# What this script is for:
# ---------------------------------------------------------
# Use this script if you want to get a list of what country
# a given domain is coming from.


# ---------------------------------------------------------
# Author:
# ---------------------------------------------------------
# Written by James Berger
# Last updated: May 1st 2013



# Below is an example comand that has the functionality we want from this script, just not in batch-friendly format
# dig +short baidu.com | head -n 1 | xargs whois | grep -i country | head -n 1 | cut -d' ' -f 9


# Run clear to keep things tidy in the console
clear

# This will grab the first argument that's used when executing our script 
# and parse it in as the file to read our domains in from.
domain_input_file=$1

# This will grab the second argument that's used when executing our script 
# and parse it in as the file to put the results in.
domain_output_file=$2

# create newline variable so it's a little easier to output
newline=$'\n'


# Create a simple header and show what the input and output files are

echo "--------------------------------------------------------"
echo "  Domain to Country Lookup Tool, v0.2"
echo $newline
echo "  User specified input file: "$1
echo "  User specified output file: "$2
echo $newline
echo "--------------------------------------------------------"
echo $newline


# Here we'll verify that the specified input file is actually a valid text file

# The command 'file' returns the file type, so we can verify if it's a text
# file without needed to worry about the file extension.
file_type=$(file $1)

# This should grab just the last bit from the output of file so that we can
# give our user the file type without all of the other stuff that comes from
# the file command. But it's not working right now.
# file_type_simple=${$file_type | cut -d' ' -f 2}

# Here's our if statement for exiting the script if the input file doesn't
# appear to be a valid text file
echo "Running input file type check..."
echo $newline

if  file $1 | grep -q "ASCII"   
  then echo "File check status: Good. The specified file is ASCII text." 
else
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!! File check status: Bad.                                  !!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!! The specified file isn't ASCII text, I can't parse that. !!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" 
  echo $newline
  echo $newline
  echo "--------------------------------------------------------------"
  echo " The file you provided has the following type: " 
  echo $newline
  echo $file_type | cut -d' ' -f 2
  echo "--------------------------------------------------------------"
#  This is for the simple file type, not working right now
#  echo $file_type_simple
fi

echo " "

# Verify that the output file doesn't already exist
# if it does, make sure the user is ok with overwriting the contents
# if it doesn't, create it

# pull in our lines from the input file

# Maybe run a regex to make sure it's a valid domain name? Sanitize our inputs
# vs running the risk of our regex saying a domain name is invalid when it isn't
# seems to be the choice

# begin loop

# run our command on each line
# add the result of the command to the output file
# check to see if we've hit the end of the file
## if we have, exit with a message indicating we're done and there's output in the output file.
#### verify that there's content in the output file?
#### if not, give an error?
## if we haven't, run another loop.

# end loop

