#!/bin/bash

# --------------------------
# Simple Page Check Utility 
# --------------------------
# Written by James Berger
# Last updated: May 22nd 2013


# Description:
# ------------
# This runs a quick check to see if our user can log in
# Curl logs into the site and places the result into a file,
# Then we grep the file and see if a string that shows up 
# when you're logged in is present. The results with a time
# stamp are echoed out and stored in a log file as well 
# so you can run this with a cron job every x number of 
# minutes to see if the site goes down at a specific time.
 
# Setting our variables
results_file="/home/YourUserName/page-check-results.html"
target_url="https://www.YourSiteHere.com/logon"
phrase_to_check_for="PhraseOnLoggedInPage"
log_file="/home/YourUserNameHere/page-check-server-status.txt"

# A function for checking the contents of the results file, this
# is for testing purposes to make sure that the bits of the script
# that work with that file are functioning correctly. If the script
# isn't working like you think it should, you can call this at 
# different points in the script to see if the file is being 
# updated, cleared out, etc.
check_results_file() {
echo -e "HERE ARE YOUR RESULTS:"
echo -e "--------------------------------------------"
cat $results_file
echo -e "--------------------------------------------\n"
}

# Quick function to create a new line, little easier than typing 
# all of the below out each time.
newline() {
echo -e "\n"
}

# Quick function to print out a separator line
dashline() {
echo -e "---------------------------------"
}

# Run clear to keep things tidy
clear


echo -e "#############################"
echo -e "# Simple Page Check Utility #"
echo -e "#############################\n"

echo -e " Current variables:"
dashline;
echo -e "The target URL is: "$target_url
echo -e "The phrase to check for is: \""$phrase_to_check_for"\""
echo -e "The file the results are stored in is: "$results_file
echo -e "The status of each check is being logged to: "$log_file
dashline;
newline;


echo -e " Results file:"
dashline;
# Create our results file if it doesn't already exist
echo -e "Checking to see if there's a file to store the results in."
if [ ! -f $results_file ]
  then
    echo -e "No results file found."
    echo -e "Creating results file" $results_file
    touch $results_file
  else
    echo -e "Results file currently exists."
    # Remove our previous results if they exist
    echo -e "Clearing out previous contents of results file."
    echo -e "" > $results_file
fi
dashline;
newline;


#check_results_file;
echo -e " HTTP status code of target URL"
dashline;
# This just makes sure that the page shows up to begin with by getting the HTTP status code of the login page.
# If it's something other than 200, then we won't be able to log in anyway.

echo -e "Running HTTP status check... "
http_status="$(curl -sL -w "%{http_code}\\n" $target_url -o /dev/null)"
echo -e "HTTP status code for the page at the target URL is: "$http_status
dashline;
newline;


echo -e " Phrase check:"
dashline;
# This logs into the site using the creds they've provided for us and the form fields from their login form.
echo -e "Running curl on the target URL."
# You can set the user agent differently if need be.
curl -A "Mozilla/4.73 [en] (X11; U; Linux 2.2.15 i686)" \
--cookie cjar --cookie-jar cjar \
--data "userName=YourUserNameHere" \
--data "password=YourPasswordHere" \
--data "login=Login" \
--location $target_url>$results_file

newline;
#check_results_file;
echo -e "Checking the contents of the results file."

if  cat $results_file | grep -q "$phrase_to_check_for"
  then 
    echo -e "Checking for the phrase \""$phrase_to_check_for"\""
    dashline;
    newline;
    echo -e " Result:"
    dashline;
    echo -e "Found the specified phrase in the results file.\n"
    echo -e "Able to successfully log in." 
    echo -e "\r\nLogin successful for $(date) with the HTTP status code $http_status" >> $log_file
    echo -e "Updating the log file now with the result for $(date)."
  else
    echo -e "Checking for the phrase " $phrase_to_check_for
    echo -e " Result:"
    dashline;
    echo -e "Did not find it in " $results_file
    echo "Failed to log in."
    echo -e "\r\nLogin failed for $(date)  with the HTTP status code $http_status" >> $log_file
    echo -e "Updating the log file now with the result for $(date)."
fi
dashline;
newline;
newline;
newline;
