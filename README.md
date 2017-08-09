PHP Server
==========

The are collection of Docker images to run PHP Server.

## Supported Tags

* `centos`
* `5`, `5-apache-alpine`,  
* `7`, `7-apache-alpine`, `latest`

## PHP Extensions installed

`ctype curl date dom fileinfo filter ftp gd gettext hash iconv intl json libxml mbstring mcrypt mysqlnd openssl pcre PDO pdo_dblib pdo_mysql pdo_pgsql pdo_sqlite pgsql Phar posix readline Reflection session SimpleXML SPL sqlite3 standard tokenizer xml xmlreader xmlwriter Zend OPcache zlib`

## Build image

```bash
$ docker build -t my-image .
```

## How to use this images

#### Environment variables

There are a few environment variables that can be passed to the container that
will enable settings.

* `DEVMODE=1` - Changes a few PHP ini directives.
 * `error_reporting = E_ALL`
 * `display_errors = On`
 * `display_startup_errors = On`
* `XDEBUG=1` - Enables XDebug module.
 * `XDEBUG_REMOTE_HOST=<HOST_IP_ADDRESS>` - Sets the remote host address for
 XDebug.
* `DOCROOT=<CONTAINER_ABSOLUTE_PATH>` - Change the `DocumentRoot` directive in Apache's `httpd.conf`.

#### Command-line

```bash
docker run -d -p 80:80 --name my-app --restart=always \
    -v .:/var/www/localhost/htdocs \
    -e DEVMODE=1 -e DOCROOT=/var/www/localhost/htdocs/Public \
    -e XDEBUG=1 -e XDEBUG_REMOTE_HOST=127.0.0.1 \
    anothy/php-server:latest
```

#### Docker Compose

```yml
version: '3'

services:
  php7:
    image: anothy/php-server:7
    restart: always
    volumes:
      - .:/var/www/localhost/htdocs
    ports:
      - 8000:80
    # Optional ENV
    environment:
      DOCROOT: /var/www/localhost/htdocs/Public/
      DEVMODE: 1
      XDEBUG: 1
      XDEBUG_REMOTE_HOST: <HOST_IP_ADDRESS>
```

#### Create a Dockerfile in your PHP project

```Dockerfile
FROM anothy/php-server:7
COPY . /var/www/localhost/htdocs
WORKDIR /var/www/localhost/htdocs
```

```bash
$ docker run -d -p 80:80 --name my-app my-app
```
