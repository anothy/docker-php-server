centos-php
==============

A Dockerfile to build a Docker image that closely resembles the Customer
Care webserver settings.  These include having the same OS, and PHP versions. As
well as include the same PHP exentions being installed.

## Stack

* Centos 6.8
* Apache 2.2
* PHP 5.6.x

## Installed PHP Extensions

`apc apcu bz2 calendar Core ctype curl date dom ereg exif fileinfo filter ftp gd gettext hash iconv intl json libxml mbstring mcrypt memcache mhash mssql mysql mysqli mysqlnd odbc openssl pcntl pcre PDO pdo_dblib pdo_mysql PDO_ODBC pdo_pgsql pdo_sqlite pgsql Phar posix pspell readline Reflection session shmop SimpleXML soap sockets SPL sqlite3 standard sysvmsg sysvsem sysvshm tokenizer wddx xml xmlreader xmlwriter xsl zip zlib`

## Requirements

You will need to have Docker installed on your machine.  If you are in Windows
or Mac you will need the Docker Toolbox.

See: https://docs.docker.com

## Usage

Build the new Docker image.

`$ docker build -t <NAME_OF_IMAGE> .`

Create a new Container.

`$ docker run -d --name customer_care -p 80:80 -v $PWD:/var/www/html <NAME_OF_IMAGE>`

The Container should now be accessible from your browser at `http://<DOCKER-MACHINE-IP>/`.

_Note: `<DOCKER-MACHINE-IP>` would be your computer IP or docker-machine's VM IP._

Docker Compose
--------------

The following pertain to the `docker-compose.yml` configuration.

## PHP Development Mode

By default the `php.ini` is set to production mode. To change your instance to
development mode, add the environment variable `DEVMODE` with the value of `true`.

Example:

```yaml
environment:
  - DEVMODE=true
```

This will update the follow directives:

* `error_reporting = E_ALL`
* `display_errors = On`
* `display_startup_errors = On`

## Apache DocumentRoot

To change Apache's DocumentRoot, add the environment variable `DOCROOT` with a value of the
absolute path in the container.

Example:

```yaml
environment:
  - DOCROOT=\/var\/www\/html\/Public
```

Note that the forward-slashes (/) are escaped.  It may be necessary to espace
any spaces as well.

## Apache Alias

To add aliases in Apache's configuration, add the environment variables
`ALIAS1` or `ALIAS2`.

Example:

```yaml
environment:
  - ALIAS1=/alias1 \/var\/www\/html\/Public
  - ALIAS2=/alias2 \/var\/www\/html\/Public
```
