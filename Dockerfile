## docker run -it -p 8080:80 -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/var/www dvo-lemp bash

FROM centos:7

MAINTAINER bobby@dvomedia.net

# update yum
RUN yum -y update --nogpgcheck; yum clean all
RUN yum -y install yum-utils

# Install some must-haves
RUN yum -y install epel-release --nogpgcheck
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget --nogpgcheck
RUN yum -y install vim --nogpgcheck
RUN yum -y install git --nogpgcheck

# install remi repo
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi-php70
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# install nginx
RUN yum -y install nginx --nogpgcheck

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# install php7
RUN yum -y install php php-common php-mbstring php-mcrypt php-devel php-xml php-mysqlnd php-pdo php-opcache --nogpgcheck

# install php pecl libraries
RUN yum -y install php-pecl-memcached php-pecl-mysql php-pecl-xdebug php-pecl-amqp --nogpgcheck

# rabbitmq-server
RUN yum -y install rabbitmq-server

# MariaDB
RUN yum -y install mariadb
RUN yum -y install mariadb-server

# bcmath, duh!
RUN yum -y install php-bcmath

# php-fpm
RUN yum -y install php-fpm

RUN yum -y install supervisor --nogpgcheck

# configs
ADD ./conf/supervisord.conf /etc/supervisord.conf
ADD ./conf/php.ini /etc/php.ini
ADD ./conf/www.conf /etc/php-fpm.d/www.conf
ADD ./conf/nginx.conf /etc/nginx/nginx.conf
ADD ./conf/default.conf /etc/nginx/conf.d/default.conf
ADD ./conf/10-opcache.ini /etc/php.d/10-opcache.ini

#maria db setup
COPY mariadb.sh /
RUN chmod 777 mariadb.sh
RUN /mariadb.sh devdb devuser devpass

# open port 80,443
EXPOSE 80 443 8080 3306

#Run nginx engine
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]
