#!/bin/bash

#-------------------------------------------------------------------------------
# Setup Docker Image.
#-------------------------------------------------------------------------------

#
# Define the Aliases
#
if [[ "${ALIAS1}" ]]; then
  echo $ALIAS1 >> /etc/httpd/conf/httpd.conf
fi
if [[ "${ALIAS2}" ]]; then
  echo $ALIAS2 >> /etc/httpd/conf/httpd.conf
fi

#
# Update Apache's DocumentRoot:
#  - DocumentRoot "/var/www/html"
#  - <Directory "/var/www/html">
#
if [[ "${DOCROOT}" ]]; then
  DOCROOT=$(echo $DOCROOT | sed -e 's/\//\\\//g')
  DOCROOT=$(echo $DOCROOT | sed -e 's/\./\\\./g')
  sed -i -- "s/^DocumentRoot \"\/var\/www\/html\"/DocumentRoot \"${DOCROOT}\"/g" /etc/httpd/conf/httpd.conf
  sed -i -- "s/^\<Directory \"\/var\/www\/html\".*/\<Directory \"${DOCROOT}\"\>/g" /etc/httpd/conf/httpd.conf
fi

#
# Update the xdebug.enabled and xdebug.remote_host in xdebug.ini.
#
if [ "${XDEBUG}" = "true" ] || [ "${XDEBUG}" = 1 ] || [[ "${XDEBUG}" ]]; then
    #
    # Enable XDebug
    #
    XDEBUG_INI="/etc/php.d/*-xdebug.ini"
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
else
    #
    # Disable XDebug
    #
    find /etc/php.d/*-xdebug.ini -type f -exec sed -i -- "s/^zend\_extension\=xdebug\.so/\;zend\_extension\=xdebug\.so/g" {} \;
fi

#
# Update php.ini to Development Mode
#
sed -i -- "s/^\;date\.timezone \=/date\.timezone \= \"America\/Toronto\"/g" /etc/php.ini
if [ "${DEVMODE}" = "true" ] || [ "${DEVMODE}" = 1 ] || [[ "${DEVMODE}" ]]; then
  sed -i -- "s/display_errors \= Off/display_errors \= On/g" /etc/php.ini
  sed -i -- "s/display_startup_errors \= Off/display_startup_errors \= On/g" /etc/php.ini
  sed -i -- "s/^error_reporting \= E\_ALL \& \~E\_DEPRECATED \& \~E\_STRICT/error_reporting \= E\_ALL/g" /etc/php.ini
fi

#
# The accelerated is over 9000!!!!!!!!
#
sed -i -- "s/^opcache\.max\_accelerated\_files.*/opcache\.max\_accelerated\_files\=9001/g" /etc/php.d/*opcache.ini

#
# Add opcache admin page alias
#
echo "Alias /opcache-admin /var/www/opcache_admin" >> /etc/httpd/conf/httpd.conf

#
# Update composer and install amnuts/opcache-gui
#
/usr/local/bin/composer self-update && composer create-project amnuts/opcache-gui /var/www/opcache_admin &
