# docker-lemp

# build it
docker build -t dvo-lemp .

# run it
docker run --name lemp2 -it -p 80:80  -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/srv -d dvo-lemp

# ssh to it
docker run -it -p 8080:80 -v /Users/bobbeh/Vagrant/centos/code/dvo-crm:/srv dvo-lemp bash

# clear all containers
docker ps -a | grep 'hours ago' | awk '{print $1}' | xargs  docker rm

