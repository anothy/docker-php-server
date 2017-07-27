PHP7 FPM Alpine & Apache 2.4 Alpine
===================================

Base Image: `php:7-fpm-alpine`

Installed Extensions:

`Core ctype curl date dom fileinfo filter ftp gd gettext hash iconv intl json libxml mbstring mcrypt mysqlnd openssl pcre PDO pdo_dblib pdo_mysql pdo_pgsql pdo_sqlite pgsql Phar posix readline Reflection session SimpleXML SPL sqlite3 standard tokenizer xml xmlreader xmlwriter Zend OPcache zlib`

Available PHP Extensions:

`bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip`

## Usage

Change directory to the location of `Dockefile`.

Build the new Docker image.

`$ docker build -t <NAME_OF_IMAGE>:<TAG> .`

Docker Compose example:

```yml
version: '2'

services:
  web:
    image: skynet.tor.indas.ca:5001/docker/php7-apache-alpine
    restart: always
    volumes:
      - .:/var/www/localhost/htdocs/
    ports:
      - 8000:80
```

## Environment Variables

There are two environment variables you can use when setting up the containers
for `php7-fpm-alpine`.  `XDEBUG` and `XDEBUG_REMOTE_HOST`.

`XDEBUG` enables the XDebug module.  It should be set to `1` to enable it.

`XDEBUG_REMOTE_HOST` should be set to your local IP Address so XDebug can find
your machine.

Docker Compose Example:

```yml
version: '2'

services:
  web:
    image: skynet.tor.indas.ca:5001/docker/php7-apache-alpine
    restart: always
    volumes:
      - .:/var/www/localhost/htdocs/
    ports:
      - 8000:80
    environment:
      XDEBUG: 1
      XDEBUG_REMOTE_HOST: 172.16.24.77
```
