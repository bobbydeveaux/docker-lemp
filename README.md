# docker-lemp

# build it
docker build -t dvo-lemp .

# run it
docker run --name lemp2 -it -p 80:80 -d dvo-lemp nginx

# clear all containers
docker ps -a | grep 'hours ago' | awk '{print $1}' | xargs  docker rm