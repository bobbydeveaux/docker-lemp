## docker run -it -p 8080:80 -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/var/www dvo-lemp bash

FROM centos:7

MAINTAINER bobby@dvomedia.net

# update yum
RUN yum -y update --nogpgcheck; yum clean all

# Install some must-haves
RUN yum -y install epel-release --nogpgcheck
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install wget --nogpgcheck
RUN yum -y install vim --nogpgcheck
RUN yum -y install git --nogpgcheck

# install remi repo
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm

# install nginx
RUN yum -y install nginx --nogpgcheck

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# install php7
RUN yum -y --enablerepo=remi,remi-test install php70 php70-php-common php70-php-mbstring php70-php-mcrypt php70-php-devel php70-php-xml php70-php-mysqlnd php70-php-pdo php70-php-opcache --nogpgcheck

# install php pecl libraries
RUN yum -y --enablerepo=remi,remi-test install php70-php-pecl-memcached php70-php-pecl-mysql php70-php-pecl-xdebug php70-php-pecl-amqp --nogpgcheck

#enable php7
RUN scl enable php70 'php -v'
RUN ln -s /usr/bin/php70 /usr/bin/php

# php-fpm (php-fpm is broken in remi?? this also installs webattic php7w-common :()
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y install php70w-fpm --nogpgcheck

RUN yum -y install supervisor --nogpgcheck

# configs
ADD ./conf/php.ini /etc/opt/remi/php70/php.ini
ADD ./conf/www.conf /etc/php-fpm.d/www.conf
ADD ./conf/default.conf /etc/nginx/conf.d/default.conf
ADD ./conf/10-opcache.ini /etc/opt/remi/php70/php.d/10-opcache.ini
ADD ./conf/supervisord.conf /etc/supervisord.conf

# open port 80,443
EXPOSE 80
EXPOSE 8080
EXPOSE 443

#Run nginx engine
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]
