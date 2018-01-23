#!/usr/bin/env bash

SDL_REPO=https://github.com/smartdevicelink/sdl_core
SDL_BRANCH=develop
SDL_POLICY=PROPRIETARY
SDL_TESTS=OFF # Possible: OFF, ON

ATF_REPO=https://github.com/smartdevicelink/sdl_atf
ATF_BRANCH=develop

SCRIPTS_REPO=https://github.com/smartdevicelink/sdl_atf_test_scripts
SCRIPTS_BRANCH=develop
TARGET=./test_scripts/Smoke/Policies/001_PTU_all_flows.lua

DOCKER_IMAGE=ubuntu_14.04:01
NUM_OF_THREADS_MAX=4

log() {
  echo "["$(date +"%Y-%m-%d %H:%M:%S,%3N")"]" "$1$2$3"
}

log "=== Starting Docker ================================================================================"
log "Docker image: "$DOCKER_IMAGE

docker run \
  -it \
  --mount type=bind,source="$PWD"/reports,target=/home/reports \
  --tmpfs /home:rw,exec,size=5242880k \
  --cap-add NET_ADMIN \
  --rm \
  -e SDL_REPO=$SDL_REPO \
  -e SDL_BRANCH=$SDL_BRANCH \
  -e SDL_POLICY=$SDL_POLICY \
  -e SDL_TESTS=$SDL_TESTS \
  -e ATF_REPO=$ATF_REPO \
  -e ATF_BRANCH=$ATF_BRANCH \
  -e SCRIPTS_REPO=$SCRIPTS_REPO \
  -e SCRIPTS_BRANCH=$SCRIPTS_BRANCH \
  -e TARGET=$TARGET \
  -e NUM_OF_THREADS_MAX=$NUM_OF_THREADS_MAX \
  -e LOCAL_USER_ID=$(id -u) \
  $DOCKER_IMAGE

log "=== Docker stopped ================================================================================="
