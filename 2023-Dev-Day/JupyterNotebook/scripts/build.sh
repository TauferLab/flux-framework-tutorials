#!/bin/sh

docker build --build-arg GLOBAL_PASSWORD=dyad_dev_day -t dyad_dev_day_hub -f Dockerfile.hub .
docker build -t dyad_dev_day_spawn -f Dockerfile.spawn .
