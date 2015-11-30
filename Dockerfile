## docker run -it -p 8080:80 -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/var/www dvo-lemp bash

FROM centos:7

MAINTAINER bobby@dvomedia.net

RUN yum -y update

RUN yum -y install epel-release

RUN yum -y groupinstall 'Development Tools'

RUN yum -y install wget

RUN yum -y install vim

RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

RUN rpm -Uvh remi-release-7*.rpm

RUN yum -y install httpd

RUN yum -y --enablerepo=remi,remi-test install php70 php70-php php70-php-common php70-php-mbstring php70-php-mcrypt php70-php-devel php70-php-xml php70-php-mysqlnd php70-php-pdo

RUN yum -y --enablerepo=remi,remi-test install php70-php-pecl-memcached php70-php-pecl-mysql php70-php-pecl-xdebug php70-php-pecl-amqp

RUN scl enable php70 'php -v'

RUN ln -s /usr/bin/php70 /usr/bin/php

RUN yum -y install git

EXPOSE 80
CMD ["/usr/sbin/httpd", "-e", "info", "-DFOREGROUND"]