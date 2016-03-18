# docker-lemp

# build it
docker build -t dvo-lemp .

# run a web tier
docker run --name lemp-frontend -it -p 80:80 -v /path/to/code:/srv -d dvo-lemp

# run a db tier
docker run --name lemp-db -it -p 3306:3306 -v /path/to/code:/srv -d dvo-lemp

# ssh to it
docker exec -i -t {containerid} bash 

# clear all containers
docker ps -a | grep 'hours ago' | awk '{print $1}' | xargs  docker rm

# clear all images
docker images | grep 'hours ago' | awk '{print $3}' | xargs docker rmi

