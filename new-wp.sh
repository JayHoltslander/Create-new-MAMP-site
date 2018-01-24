#!/bin/bash

clear

# PROMPT USER FOR THE SITE'S URL
echo What is the domain name and extension of the new site? eg: wordpress.org

# MAKE THE USER'S RESPONSE A NEW VARIABLE
read domainname

# DOWNLOAD THE LATEST WORDPRESS TO A NEW FOLDER IN MAMP'S HTDOCS FOLDER, NAMED BY THE VARIABLE
echo Downloading Wordpress to the new folder $domainname in the MAMP htdocs folder.
echo 
echo wget -P /Applications/MAMP/htdocs/$domainname http://wordpress.org/latest.tar.gz
wget -P /Applications/MAMP/htdocs/$domainname http://wordpress.org/latest.tar.gz

# CHANGE DIRECTORY TO THE NEWLY CREATED FOLDER
echo cd /Applications/MAMP/htdocs/$domainname
cd /Applications/MAMP/htdocs/$domainname
echo

# NOW UNZIP THE WORDPRESS ZIP FILE LOCATED IN THERE
echo Unzipping...
tar xfz latest.tar.gz
echo

# MOVE THE UNZIPPED FILES ONE LEVEL UP
echo Cleaning up...
mv wordpress/* ./
echo

# GET RID OF THE NOW EMPTY WORDPRESS FOLDER
rmdir ./wordpress/

# GET RID OF THE DOWNLOADED AND UNZIPPED WORDPRESS ZIP FILE
rm -f latest.tar.gz

echo All done! The $domainname site folder is now ready within MAMPs htdocs folder.
echo
echo You can close this window now.
exit
