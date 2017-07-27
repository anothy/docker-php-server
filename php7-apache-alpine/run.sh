#!/bin/sh

#
# Update Apache's DocumentRoot
#
if [[ "$DOCROOT" ]]; then
  # Escape forward-slashes and periods.
  DOCROOT=$(echo $DOCROOT | sed -e 's/^\(.*\)\/$/\1/g')
  DOCROOT=$(echo $DOCROOT | sed -e 's/\//\\\//g')
  DOCROOT=$(echo $DOCROOT | sed -e 's/\./\\\./g')
  # Update DocumentRoot
  sed -i -- "s/^DocumentRoot \"\/var\/www\/localhost\/htdocs\"$/DocumentRoot \"$DOCROOT\"/g" /etc/apache2/httpd.conf
  sed -i -- "s/^<Directory \"\/var\/www\/localhost\/htdocs\">$/\<Directory \"$DOCROOT\"\>/g" /etc/apache2/httpd.conf
  # Update ProxyPassMatch
  sed -i -- "s/^\(ProxyPassMatch.*9000\).*/\1$DOCROOT\/\$1/g" /etc/apache2/httpd.conf
fi

#
# Update the xdebug.enabled and xdebug.remote_host in xdebug.ini.
#
XDEBUG_INI="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
if [ "${XDEBUG}" = "true" ] || [ "${XDEBUG}" = 1 ] || [[ "${XDEBUG}" ]]; then
  #
  # Enable XDebug
  #
  echo "" >> $XDEBUG_INI
  echo ";------------------------------------------------------------" >> $XDEBUG_INI
  echo "; Docker Build setup" >> $XDEBUG_INI
  echo "" >> $XDEBUG_INI
  echo "xdebug.remote_enable=1" >> $XDEBUG_INI
  echo "xdebug.remote_handler=dbgp" >> $XDEBUG_INI
  echo "xdebug.remote_port=9000" >> $XDEBUG_INI
  echo "xdebug.remote_autostart=1" >> $XDEBUG_INI
  echo "xdebug.remote_connect_back=0" >> $XDEBUG_INI
  echo "xdebug.idekey=docker"  >> $XDEBUG_INI
  echo "xdebug.remote_host=${XDEBUG_REMOTE_HOST}" >> $XDEBUG_INI
  mv /etc/apache2/conf.d/proxy_timeout.conf.disabled /etc/apache2/conf.d/proxy_timeout.conf
else
  #
  # Disable XDebug
  #
  sed -i -- "s/^\(zend_extension\=.*\)/\;\1/g" $XDEBUG_INI
fi

#
# Show errors if in Development Mode (DEVMODE).
#
if [ ! -f /usr/local/etc/php/php.ini ]; then
  rm /usr/local/etc/php/php.ini
fi

if [ "${DEVMODE}" = "true" ] || [ "${DEVMODE}" = 1 ] || [[ "${DEVMODE}" ]]; then
  cp /php_inis/php.ini.devmode-on /usr/local/etc/php/php.ini
else
  cp /php_inis/php.ini.devmode-off /usr/local/etc/php/php.ini
fi

#
# Run Apache
#
apachectl -DBACKGROUND

# Run PHP FPM
#
php-fpm
