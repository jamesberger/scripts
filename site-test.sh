#!/bin/bash

# --------------------------
# Simple Page Check Utility 
# --------------------------
# Written by James Berger
# Last updated: May 999999999th 2013


# Description:
# ------------
# This runs a quick check to see if our user can log into a website
# Curl logs into the site and places the resulting logged in page 
# into a file. Then we grep the file and see if a string that shows 
# up when you're logged in is present. If so, it does nothing.
# If not, it alerts you.

#Setting our variables
results_file=/tmp/simple-page-check_server-page.html
target_url=https://www.your-site-goes-here.com/login.html
phrase_to_check_for=PutYourPhraseThatShowsUpOnTheLoggedInPageHere #note - need to fix this so you can set it to something with spaces in it instead of a single word
log_file=/tmp/simple-page-check_server-status-log.txt

# Run clear to keep things tidy
clear

echo -e "#############################"
echo -e "# Simple Page Check Utility #"
echo -e "#############################\n"

# This just makes sure that the page shows up to begin with by getting the HTTP status code of the login page.
# If it's something other than 200, then we won't be able to log in anyway.

echo -e "Running HTTP status check... \n"
echo -e "HTTP status code for the page at "$target_url "is: " 
echo -e "-------"
curl -sL -w "%{http_code}\\n" $target_url -o /dev/null
echo -e "-------"

echo -e "\n"

# This logs into the site using the creds you specify and the form fields from the login form on the target site.
# Note: You may have to update these fields depending on how the form on the target page is requesting the data.
# If the form asks for a variable "userName", you're good. If it's called something different, then change
# "userName" to whatever it's looking for.
# So --data "userName=YourUserNameGoesHere" \ could become --data "User=YourUserNameGoesHere" \ for example.

echo "Running curl on the page at " $target_url
echo -e "-----------------------------------------\n\n"
curl -A "Mozilla/4.73 [en] (X11; U; Linux 2.2.15 i686)" \
--cookie cjar --cookie-jar cjar \
--data "userName=YourUserNameGoesHere" \
--data "password=YourPasswordGoesHere" \
--data "login=Login" \
--location $target_url>$results_file

echo -e "\n"

echo -e "Checking the contents of "$results_file "\n"
echo -e "... \n"

# replaced "logged in" with a variable, but it's not parsing both words for some reason
# which means that I've had to set the variable to a single word only. Not ideal, but
# it works, so I'm just going to leave this line here to remind myself to fix this. 
#if  cat $results_file | grep -q "logged in"


if  cat $results_file | grep -q $phrase_to_check_for
  then 
    echo "Able to successfully log in." 
    echo -e "\r\nLogin successful for $(date)" >> $log_file
    echo -e "Updating " $log_file "now with the result for the login attempt on $(date)."
  else
    echo "Failed to log in."
    echo -e "\r\nLogin failed for $(date)" >> $log_file
    echo -e "Updating " $log_file "now with the result for the login attempt on $(date)."
fi

echo -e "\n\n\n"
