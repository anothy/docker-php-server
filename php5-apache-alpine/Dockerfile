FROM php:5-fpm-alpine

LABEL Description="PHP 5.6 FPM Alpine and Apache 2.4 Alpine"

ARG xdebug=0
ARG devmode=0

#
# Install
# - Apache2 and Apache2 modes
# - Add some additional PHP Extensions.
#
RUN apk update && \
    apk add --no-cache freetds-dev libmcrypt-dev postgresql-dev \
      apache2 apache2-utils apache2-proxy apache2-ssl \
      libpng-dev icu-dev gettext-dev \
      freetds libpq autoconf alpine-sdk && \
    docker-php-source extract && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-source delete && \
    docker-php-ext-install \
      gd \
      gettext \
      iconv \
      intl \
      opcache \
      pdo \
      pdo_dblib \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      mcrypt && \
    apk del autoconf alpine-sdk && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir -p /run/apache2 && \
    chown www-data:www-data /run/apache2

#
# Copy php.ini
#
# /usr/local/etc/php/php.ini
#
COPY config/php.ini.devmode-off /php_inis/php.ini.devmode-off
COPY config/php.ini.devmode-on /php_inis/php.ini.devmode-on

#
# Copy Apache2 config files
#
COPY config/httpd.conf /etc/apache2/httpd.conf
COPY config/slotmem_shm.conf /etc/apache2/conf.d/slotmem_shm.conf
COPY config/proxy_timeout.conf /etc/apache2/conf.d/proxy_timeout.conf.disabled

#
# setup.sh setups up the
#
COPY setup.sh /setup.sh
COPY run.sh /run.sh

#
# Copy the entrypoint script
#
COPY entrypoint.sh /entrypoint.sh

#
# Make scripts executable
#
RUN chmod +x /setup.sh && chmod +x /run.sh && chmod +x /entrypoint.sh

#
# Expose port 80
#
EXPOSE 80

#
# Set working directory
#
WORKDIR /var/www/localhost/htdocs/

ENV XDEBUG=${xdebug}
ENV DEVMODE=${devmode}

#
# Set entrypoint
#
ENTRYPOINT ["/entrypoint.sh"]
