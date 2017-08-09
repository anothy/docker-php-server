#!/bin/sh

#
# Run Apache
#
apachectl -DBACKGROUND

# Run PHP FPM
#
php-fpm
