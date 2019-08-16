#!/bin/bash

set -xe

echo " >> Correcting permissions on /var/www/html"
chown www-data:www-data /var/www/html /data -R
