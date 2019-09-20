#A repo for Bash shell scripts I've written

#modify-AWS-DeleteOnTermination-flag.sh
A Bash script that allows you to alter the DeleteOnTermination flag on EBS volumes for AWS instances.
This flag is set to 'True' by default so you don't have a bunch of EBS volumes sitting around after you terminate your AWS instances.
However, when troubleshooting ASG issues where the unhealthy instance is terminated before you can dig into it to find the root cause,
having the root volume deleted can make it difficult to troubleshoot more complex health check failures.

Note - This will only modify the tag for existing instances. New instances will default back to **DeleteOnTermination=true**.
You would need to modify the AMI the ASG is using to alter this flag on a permanent basis. However, unless you're a fan of setting
money on fire, you will most likely not want to set this to true permanently.

#check-for-instances.sh
This gets the instance name for a file containing a list of AWS instance IDs and saves the results to a log file.

#load-test.sh
A simple Bash script I wrote years ago that will send an email from a Linux server if the system load is greater than the value you specify.
Good for machines that don't have monitoring agents on them. Typically something you would run via a cron job.

#site-test.sh
A somewhat over-complicated Bash script that I wrote years ago that logs into a website and checks for a word in the resulting page
and logs success or failure to a log file. Used for troubleshooting.
