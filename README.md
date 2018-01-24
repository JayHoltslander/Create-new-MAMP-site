# Create-new-MAMP-site
A bash shell script to create new sites easily within MAMP.

## What it does (automatically)
1. Prompts you for a site url.
2. Downloads the latest version of Wordpress from Wordpress.org to a folder named after your site's url within MAMP's htdocs folder
3. Unzips the downloaded file
4. Moves the files to their proper place
5. Deletes the downloaded zip and leftovers
6. Opens your default browser to the new Wordpress site's setup screen (MAMP must be running!)
7. Opens Chrome to MAMP's phpMyAdmin for you to create a new database in. (MAMP must be running!)

## Installation
1. The file **new-wp.sh** needs to be placed in your Mac's ``usr/local/bin`` folder so that it can be run from any folder you may be in.
That folder is a system folder and will be invisible within Finder by default. To make hidden system folders and files visible you will need to... (Instructions go here)

2. Before you can run **new-wp.sh** you will need to change it's permissions so that it will run properly. This needs to be done only once and is done by entering the following command. ``chmod u+x /usr/local/bin/new-wp.sh``

3. Now you can open Terminal.app on your Mac at any time and type ``new-wp.sh`` to create a new site

