#!/bin/bash
# 
#	This script is for demonstration purposes ONLY !!! NOT FOR PRODUCTION USAGE
#

#### CHANGE ME ####
AUTH_URL=http://showcase.rcip.redhat.com:5000/v2.0


echo -n  "please enter backup name : "
read bkp_name

echo -n  "please enter containers folder name : "
read folder

echo -n "please enter your swift username : "
read swift_user

echo -n "please enter your swift password : "
read -s swift_pwd

ssh db01 "mysqldump -u root -p'mariaroot' wp > $bkp_name"

if [ $? -eq 0 ]; then

	echo "backup succesfull, now sending to swift"
else
	echo "backup failed, exiting"
fi


ssh db01 "swift --os-auth-url $AUTH_URL  --os-username $swift_user --os-password $swift_pwd --os-tenant-name $swift_user upload $folder $bkp_name"

if [ $? -eq 0 ]; then

	echo -e "\n Backup succesfully sent to swift !!!"
else
	echo "Upload to swift failed"
fi
