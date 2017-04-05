FROM docker.io/centos:7
MAINTAINER jason.cross@linkup.com

# install Remi's software collections based php
RUN yum makecache && \
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y php70 \
# php70-php includes the php module for apache httpd
                   php70-php \
# multi-byte string extension
                   php70-php-mbstring \
# pdo extension (database abstraction)
                   php70-php-pdo \
# xml extension (reading/writing xml)
                   php70-php-xml \
# files needed to compile new extensions against php
                   php70-php-devel \
# mysql php native driver 
                   php70-php-mysqlnd \
# arbitrary precision mathetics functions
                   php70-php-bcmath \
# pear, for installing pear packages
                   php70-php-pear \
# xdebug pecl extension
                   php70-php-pecl-xdebug \
# apache httpd
                   httpd \
# ssl support for httpd
                   mod_ssl \
# git is generally need by things like composer
                   git && \
    yum clean all && \
# enable scl php 7.0 in bash login shells
    echo 'source scl_source enable php70' > /etc/profile.d/scl-php70.sh && \
# create a directory for logs
    mkdir /var/opt/remi/php70/log/php && \
    chown apache:root /var/opt/remi/php70/log/php && \
    chmod 770 /var/opt/remi/php70/log/php && \
# disable the xdebug extension by default
    sed -i 's/zend_extension=/;zend_extension=/' /etc/opt/remi/php70/php.d/15-xdebug.ini

# Install phpunit
RUN curl -L -o /usr/bin/phpunit https://phar.phpunit.de/phpunit-6.0.9.phar && \
    chmod 755 /usr/bin/phpunit

# Install composer
RUN scl enable php70 -- bash -c "\
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin" && \
    ln -s /usr/bin/composer.phar /usr/bin/composer

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY zz98-custom-overrides.ini /etc/opt/remi/php70/php.d/zz98-custom-overrides.ini


# Set up web root
RUN mkdir -p /var/www/html && \
# fix permissions/ownership of docker-entrypoint.sh
    chmod 755 /docker-entrypoint.sh && \
    chown root:root /docker-entrypoint.sh && \
# create a directory to hold docker run time set up files, if any
    mkdir /docker-setup

# pass all commands to /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# the standard command to run apache httpd
CMD ["/usr/sbin/httpd", "-k", "start", "-D", "FOREGROUND"]

Expose 80 443
