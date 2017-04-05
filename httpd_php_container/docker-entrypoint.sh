#!/bin/bash

if [ -f '/docker-setup/setup-done' ]
then
  # container is already setup, so just run the command
  exec "$@"
fi

touch /docker-setup/setup-done

php_overrides_file='/etc/opt/remi/php70/php.d/zz98-custom-overrides.ini'

if [ "${ENABLE_XDEBUG:-0}" -eq 1 ]
then
  echo "Enabling xdebug..."
  echo 'zend_extension=xdebug.so' >> "$php_overrides_file"
  echo 'xdebug.remote_enable=on' >> "$php_overrides_file"
  echo 'xdebug.remote_connect_back=on' >> "$php_overrides_file"
fi

exec "$@"
