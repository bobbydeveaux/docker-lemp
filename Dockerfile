## docker run -it -p 8080:80 -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/var/www dvo-lemp bash

FROM centos:7

MAINTAINER bobby@dvomedia.net

# update yum
RUN yum -y update

# Install some must-haves
RUN yum -y install epel-release
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install wget
RUN yum -y install vim
RUN yum -y install git

# install remi repo
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm

# install apache
RUN yum -y install httpd

# add httpd conf
COPY testing.conf /etc/httpd/conf.d/

# install php7
RUN yum -y --enablerepo=remi,remi-test install php70 php70-php php70-php-common php70-php-mbstring php70-php-mcrypt php70-php-devel php70-php-xml php70-php-mysqlnd php70-php-pdo

# install php pecl libraries
RUN yum -y --enablerepo=remi,remi-test install php70-php-pecl-memcached php70-php-pecl-mysql php70-php-pecl-xdebug php70-php-pecl-amqp

#enable php7
RUN scl enable php70 'php -v'
RUN ln -s /usr/bin/php70 /usr/bin/php

# open port 80,443

EXPOSE 80
EXPOSE 443
CMD ["/usr/sbin/httpd", "-e", "info", "-DFOREGROUND"]