#!/usr/bin/env bash
HOST_WORK_FOLDER=/home/db/git/openSDL/sdl_server
CONTAINER_WORK_FOLDER=/home/developer/sdl_server

docker run \
  -it \
  --rm \
  -e LOCAL_USER_ID=$(id -u) \
  -v $HOST_WORK_FOLDER:$CONTAINER_WORK_FOLDER \
  ubuntu_16.04:PolicyServer
