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
# Last updated: March 12th 2013
#
# Notes: Dig already has a batch
# feature, this is just to test
# CLI / Python integration.
#
#####################################


from subprocess import call

with open('batch-dig-input.txt') as infile, open('batch-dig-output.txt', 'w') as outfile:

  for line in infile:
 
    call(['dig', line.strip()], stdout=outfile)


