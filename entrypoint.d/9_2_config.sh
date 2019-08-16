#!/bin/bash

set -xe

echo " >> Preparing config.php in case it does not exist"

if [[ ! -f /data/config.php ]]; then
    j2 /.data.template/config.php.j2 -f env > /data/config.php
fi

if [[ -f /data/config.php ]] && [[ ! -f /var/www/html/config.php ]]; then
    ln -s /data/config.php /var/www/html/config.php
fi
