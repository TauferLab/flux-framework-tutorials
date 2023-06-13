#!/bin/sh

docker network ls | grep jupyterhub

if test $? -ne 0; then
    docker network rm jupyterhub
fi

docker network create jupyterhub

docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
    --net jupyterhub --name jupyterhub -p 8000:8000 dyad_dev_day_hub
