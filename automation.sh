#!/bin/bash

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
