#!/bin/bash
# THIS FILE CAN BE DROPPED IN ``usr/local/bin/``

clear

# PROMPT USER FOR THE SITE'S URL
echo What is the domain name and extension of the website you are building? eg: skunkworks.ca
	# MAKE THE USER'S RESPONSE A NEW VARIABLE
	read domainname

# PROMPT USER FOR PRODUCTION SERVER'S IP ADDRESS
echo What is the true IP address of the $domainname server? This is where existing themes and plugins will be fetched from. eg: 192.123.321.9
	# MAKE THE USER'S RESPONSE A NEW VARIABLE
	read ipaddress

# PROMPT USER FOR PRODUCTION SERVER'S APP NAME
echo What is the Production servers App name as defined in ServerPilot?
	# MAKE THE USER'S RESPONSE A NEW VARIABLE
	read appname


# DOWNLOAD THE LATEST WORDPRESS TO A NEW FOLDER IN MAMP'S HTDOCS FOLDER, NAMED BY THE VARIABLE
echo Downloading Wordpress to the new folder $domainname in the MAMP htdocs folder.
echo 
echo && wget -P /Applications/MAMP/htdocs/$domainname http://wordpress.org/latest.tar.gz

# CHANGE DIRECTORY TO THE NEWLY CREATED FOLDER
echo && cd /Applications/MAMP/htdocs/$domainname
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


# CREATE ROBOTS.TXT
{
	echo User-agent: \*
	echo Disallow: /.git
	echo Disallow: /cgi-bin
	echo Disallow: /config
	echo Disallow: /storage
	echo Disallow: /wp-admin
	echo Disallow: /wp-content/plugins/
	echo Disallow: /wp-content/cache/
	echo 
	echo \# DO NOT REMOVE THIS LINE. IT IS MONITORED FOR CHANGES BY STATUSCAKE.
	echo Sitemap: https://$domainname/sitemap.xml
} >robots.txt


# CREATE STAGING-ROBOTS.TXT
{
	echo User-agent: \*
	echo Disallow: /
} >robots-staging.txt


# CREATE .HTACCESS
{
echo \# BEGIN WordPress
echo \<IfModule mod_rewrite.c\>
echo RewriteEngine On
echo RewriteBase /
echo RewriteRule ^index\\.php$ - [L]
echo RewriteCond %{REQUEST_FILENAME} !-f
echo RewriteCond %{REQUEST_FILENAME} !-d
echo RewriteRule . /index.php [L]
echo \</IfModule\>
echo \# END WordPress
echo 
echo 
echo \# REDIRECT ROBOTS.TXT REQUESTS TO STAGING SERVER'S VERSION IF NOT PRODUCTION SERVER'S DOMAIN
echo \# Serve a different \("Do not index"\) version of robots.txt only when accessed on a subdomain of "stagingserver.com"
echo \# Make sure file "robots-staging.txt" actually exists.
echo \# Source: https://serverfault.com/a/884023/396075
echo \#
echo \<IfModule mod_rewrite.c\>
echo 		RewriteEngine On
echo 		RewriteBase /
echo 		RewriteCond %{HTTP_HOST} ^\(.*\)?skunk\(\\.ws\)
echo 		RewriteRule ^robots\\.txt$ robots-staging.txt [NS]
echo \</IfModule\>
} >.htaccess

# DELETE README.HTML
echo Deleting readme.html
rm -f readme.html

# DELETE LICENCE.TXT
echo Deleting licence.txt
rm -f license.txt

# DELETE HELLO DOLLY & AKISMET PLUGINS
echo Deleting junk plugins...
rm -r wp-content/plugins/hello.php
rm -r wp-content/plugins/akismet
echo

# DELETE DEFAULT THEMES
echo Deleting themes...
rm -r wp-content/themes/twenty*
echo

# FETCH THE THEMES DIRECTORY FROM PRODUCTION
# echo Fetching Themes folder contents from Production...
# echo scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/themes/ /Applications/MAMP/htdocs/$domainname/wp-content/themes
# scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/themes/ /Applications/MAMP/htdocs/$domainname/wp-content/themes
# echo

# FETCH THE PLUGINS DIRECTORY FROM PRODUCTION
# echo Fetching Plugins folder contents from Production...
# echo scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/plugins/ /Applications/MAMP/htdocs/$domainname/wp-content/plugins
# scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/plugins/ /Applications/MAMP/htdocs/$domainname/wp-content/plugins
# echo

# FETCH THE MU-PLUGINS DIRECTORY FROM PRODUCTION
# echo Fetching MU-Plugins folder contents from Production...
# echo scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/mu-plugins/ /Applications/MAMP/htdocs/$domainname/wp-content/mu-plugins
# scp -r serverpilot@$ipaddress:apps/$appname/public/wp-content/mu-plugins/ /Applications/MAMP/htdocs/$domainname/wp-content/mu-plugins
# echo

# CHANGE DIRECTORY TO THE PLUGINS FOLDER
echo && cd /Applications/MAMP/htdocs/$domainname/wp-content/plugins


# DOWNLOAD ESSENTIAL PLUGINS
echo Downloading essential plugins...

	# INDIVIDUAL FILES 
	#wget --quiet -P ./ https://downloads.wordpress.org/plugin/login-recaptcha.1.1.10.zip
	#wget --quiet -P ./ https://downloads.wordpress.org/plugin/cloudflare.3.3.2.zip
	#wget --quiet -P ./ https://downloads.wordpress.org/plugin/wordpress-seo.6.2.zip

	# FROM A REMOTE URL'S LIST OF FILES
	wget -i http://git.skunk.ws/public-repos/wp-plugins-list/raw/master/list.txt

	# UNZIP ALL DOWNLOADED ESSENTIAL PLUGINS
	echo Unzipping all downloaded plugins...
	unzip -q \*.zip
	echo
	# GET RID OF THE DOWNLOADED AND UNZIPPED WORDPRESS ZIP FILE
	echo Cleaning up...
	rm -f *.zip
	rm -f list.txt


echo All done! The $domainname site folder is now ready within MAMPs htdocs folder.
echo
echo You can close this window now.

# OPEN THE NEW WEBSITE IN THE BROWSER
open http://localhost:8888/$domainname/

# OPEN CHROME TO MAMPS PHPMYADMIN "NEW DATABASE" SCREEN.
open -na 'Google Chrome' --args --new-window http://localhost:8888/phpMyAdmin/server_databases.php?server=1

exit
