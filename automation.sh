#!/bin/bash
#dev branch
s3_bucket="upgrad-rutik"
name="rutik"

apt update -y
#Checking apache2 is installed or not
if ! dpkg -s apache2 > /dev/null 2>&1; then
 apt install apache2 -y
fi
#Checking apache2 service is running or not
systemctl start apache2
systemctl enable apache2

# Creating tar archive of apache2 access and error logs
timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cvf /tmp/${name}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

# Uploading the tar archive file to S3 bucket
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://upgrad-rutik/${name}-httpd-logs-${timestamp}.tar


#init variable
docroot="/var/www/html"

#Check the file exits or not
if [[ ! -f ${docroot}/inventory.html ]]; then
echo -e "Log Type\t\tTime Created\t\tType\t\tSize" > ${docroot}/inventory.html
fi

#Inserting logs into file
if [[ -f ${docroot}/inventory.html ]]; then
size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}')
echo -e "httpd-logs\t\t${timestamp}\t\ttar\t\t${size}" >>${docroot}/inventory.html
fi

#Creating a Cron Job
if [[ ! -f /etc/cron.d/automation ]]; then
echo "* * * * * root /root/Automation_Project/Automation_Project/automation.sh" >> /etc/cron.d/automation
fi




