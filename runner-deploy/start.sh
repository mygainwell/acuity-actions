#!/bin/bash

i=1;
while [ $i -le $1 ] 
do
    docker-machine create \
        --driver amazonec2 \
        --amazonec2-region "us-east-1" \
        --amazonec2-root-size "16" \
        --engine-install-url "https://releases.rancher.com/install-docker/19.03.9.sh" \
        runner-node-$i;
    i=$((i + 1));
done

docker-machine ssh runner-node-1 -- sudo docker swarm init --advertise-addr $(docker-machine ip runner-node-1)

ip=$(docker-machine ip runner-node-1);
token=$(docker-machine ssh runner-node-1 -- sudo docker swarm join-token -q worker);

i=2;
while [ $i -le $1 ]
do
    docker-machine ssh runner-node-$i -- sudo docker swarm join --token $token $ip:2377;
    i=$((i + 1));
done

eval $(docker-machine env runner-node-1)
docker stack deploy --compose-file=docker-compose.yml actions

docker service scale actions_runner=$1