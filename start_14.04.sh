#!/usr/bin/env bash
HOST_WORK_FOLDER=~/workspace/$1
CONTAINER_WORK_FOLDER=/home/developer/sdl

docker run \
	-it \
	--rm \
	--cap-add NET_ADMIN \
	-e LOCAL_USER_ID=$(id -u) \
	-v $HOST_WORK_FOLDER:$CONTAINER_WORK_FOLDER \
	ubuntu_14.04:01
