FROM centos:6.8

LABEL Description="Basic Customer Care Image"

#
# Copy ius.repo to /etc/yum.repos.d/ius.repo
#
COPY ./conf/yum/ius.repo /ius.repo

#
# 1. Install the EPEL and IUS Repos
# 2. Update the ius.repo
# 3. Install httpd
# 4. Install php56u and all necessary PHP extensions.
# 5. Do a yum update
# 6. Clean yum cache
#
RUN yum install wget epel-release -y && \
    wget https://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-15.ius.centos6.noarch.rpm -O /ius-release.rpm && \
    rpm -Uvh /ius-release.rpm && \
    rm -f /ius-release.rpm && \
    mv /ius.repo /etc/yum.repos.d/ius.repo && \
    yum install -y \
        httpd \
        php56u \
        php56u-apcu \
        php56u-gd \
        php56u-gettext \
        php56u-intl \
        php56u-mbstring \
        php56u-mcrypt \
        php56u-memcache \
        php56u-mssql \
        php56u-mysql \
        php56u-mysqli \
        php56u-mysqlnd \
        php56u-odbc \
        php56u-opcache \
        php56u-pecl-ssh2 \
        php56u-pecl-xdebug \
        php56u-pdo \
        php56u-pdo_dblib \
        php56u-pdo_mysql \
        php56u-pdo_odbc \
        php56u-pdo_pgsql \
        php56u-pdo_sqlite \
        php56u-pgsql \
        php56u-pspell \
        php56u-soap \
        php56u-sqlite3 && \
    yum update -y && \
    yum clean all

#
# Output the httpd access_log to stdout.
#
RUN ln -sf /dev/stdout /var/log/httpd/access_log

#
# Copy freetds/freetds.conf to /etc/freetds.conf
#
COPY ./conf/freetds/freetds.conf /etc/freetds.conf

#
# Copy httpd.conf
#
COPY ./conf/httpd/httpd.conf /etc/httpd/conf/httpd.conf

#
# Setup Script
#
COPY ./setup.sh /setup.sh

#
# Setup Run
#
COPY ./run.sh /run.sh

#
# Entry Point Script
#
COPY entrypoint.sh /entrypoint.sh

#
# Copy Composer
#
COPY composer.phar /usr/local/bin/composer

#
# Make scripts executable
#
RUN chmod +x /setup.sh && chmod +x /run.sh && chmod +x /entrypoint.sh

#
# Set working directory
#
WORKDIR /var/www/html

#
# Expose default HTTPD port.
#
EXPOSE 80

#
# Start Apache in the foreground
#
ENTRYPOINT ["/entrypoint.sh"]
