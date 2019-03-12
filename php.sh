#!/bin/bash
sudo yum update -y 
sudo yum install -y epel-release
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum update -y
sudo yum install -y php71w-bcmath php71w-cli mod_php71w php71w-common php71w-dba php71w-devel php71w-embedded php71w-enchant php71w-fpm php71w-gd php71w-imap php71w-interbase php71w-intl php71w-ldap php71w-mbstring php71w-mcrypt php71w-mysqlnd php71w-odbc php71w-opcache php71w-pdo php71w-pdo_dblib php71w-pear php71w-pecl-apcu php71w-pecl-apcu-devel php71w-pecl-geoip php71w-pecl-igbinary php71w-pecl-igbinary-devel php71w-pecl-imagick php71w-pecl-imagick-devel php71w-pecl-libsodium php71w-pecl-memcached php71w-pecl-mongodb php71w-pecl-redis php71w-pecl-xdebug php71w-pgsql php71w-phpdbg php71w-process php71w-pspell php71w-recode php71w-snmp php71w-soap php71w-tidy php71w-xml php71w-xmlrpc
