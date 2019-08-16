#!/bin/bash

set -xe

echo " >> Deploying application update with composer"
su www-data -s /bin/bash -c "cd /var/www/html && composer install"
