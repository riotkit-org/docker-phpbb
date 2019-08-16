#!/bin/bash

set -xe

if [[ -f /var/www/html/config.php ]] && [[ "$(cat /var/www/html/config.php)" == *"'PHPBB_INSTALLED', true"* ]]; then
    echo " >> Running migrations..."
    su www-data -s /bin/bash -c "cd /var/www/html && ./bin/phpbbcli.php db:migrate --safe-mode"
fi
