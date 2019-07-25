#!/usr/bin/env bash

docker run \
  -it \
  --rm \
  -p 8087:8087 \
  -p 12345:12345 \
  -p 80:80 \
  -p 5050:5050 \
  -v $(pwd)/sdl_shared:/home/developer/sdl \
  -e LOCAL_USER_ID=$(id -u) \
  ubuntu_16.04:latest $@
