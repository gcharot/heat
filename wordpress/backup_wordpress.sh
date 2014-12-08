#!/bin/bash

# 
#	This script is for demonstration purposes ONLY !!!
#

echo -n  "please enter backup name : "
read bkp_name

echo -n "please enter your swift username : "
read swift_user

echo -n "please enter your swift password : "
read -s swift_pwd

ssh db01 "mysqldump -u root -p'mariaroot' wp > $bkp_name"
echo

if [ $? -eq 0 ]; then

	echo "backup succesfull, now sending to swift"
else
	echo "backup failed, exiting"
fi


ssh db01 "swift --os-auth-url https://ca.enocloud.com:5000/v2.0  --os-username $swift_user --os-password $swift_pwd --os-tenant-name $swift_user upload WP $bkp_name"

if [ $? -eq 0 ]; then

	echo "backup succesfully sent to swift, URL is https://ca.enocloud.com:8080/v1/AUTH_2e9fcfaa8a9f4e0aae8f4404088c8178/WP/$bkp_name"
else
	echo "Upload to swift failed"
fi
