#!/usr/bin/python
#!python

#####################################
#  
# Batch Dig Utility
#				
# Version 0.1
#
# Written by James Berger
#
# Last updated: March 13th 2013
#
# Notes: Dig already has a batch
# feature, this is just to test
# CLI / Python integration.
#
#####################################


from subprocess import call


  # We'll display what the input is so the user knows what to expect in the output file
  print "\n"
  print "*************************************************************************************************"
  print "* Welcome to the Batch Dig Utility!                                                             *"
  print "*                                                                                               *"
  print "* (Dig has a batch lookup feature, this is just a Python proof of concept for CLI interaction.) *"
  print "*                                                                                               *"
  print "*************************************************************************************************\n\n"
  print "Your input is as follows: \n"


# Essentially, we want to run the following command:
# dig +short google.com | head -n 1 | xargs whois | grep -i country | head -n 1 | cut -d' ' -f 9
# 
# This gets us the first IP for the domain, pipes it into whois, greps (-i for no case sensitivity) for the 
# country, grabs the first result, then uses cut to get just the country name. This is a bit fragile, as it
# relies on the output from these various commands being the same on any computer this is run on.


# with open('batch-dig-input.txt') as infile, open('batch-dig-output.txt', 'w') as outfile:
# 
#   for line in infile:
  
    print line

  print "\n\n"
  print "Now running dig on the items in the input file...\n"

  for line in infile:
 
    call(['dig', line.strip()], stdout=outfile)

  print "Finished. More work sir?\n"


