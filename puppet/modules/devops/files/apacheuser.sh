#!/bin/bash
#
# This script will set the apache runtime to vagrant:vagrant
# :: Must be run as root
#

USER=vagrant

# Set envvars user and group
sed -i "s/www-data/$USER/g" /etc/apache2/envvars

# Chown apache lock file
chown $USER:$USER /var/lock/apache2

# Chown php session store
chown -R $USER:$USER /var/lib/php5

# Done
echo "Apache now set to run as user $USER";
exit 0;