#!/usr/bin/env bash
# HOST_SRC_FOLDER=~/workspace/0
# HOST_WORK_FOLDER=~/ramdrv
CONTAINER_WORK_FOLDER=/home/developer/sdl
# REPORT_FOLDER=~/ramdrv/TestingReports

# if [ ! -d $REPORT_FOLDER/WS_$1 ] ; then
#   mkdir $REPORT_FOLDER/WS_$1
# fi

docker run \
  -it \
  --rm \
  --cap-add NET_ADMIN \
  -e LOCAL_USER_ID=$(id -u) \
  -v ~/ramdrv/b:$CONTAINER_WORK_FOLDER/b \
  -v ~/git/sdl/sdl_core:$CONTAINER_WORK_FOLDER/sdl_core \
  -v ~/git/sdl/sdl_atf:$CONTAINER_WORK_FOLDER/sdl_atf \
  -v ~/git/sdl/sdl_atf_test_scripts:$CONTAINER_WORK_FOLDER/sdl_atf_test_scripts \
  -v ~/ramdrv/TestingReports:$CONTAINER_WORK_FOLDER/TestingReports \
  -v ~/ramdrv/b_atf:$CONTAINER_WORK_FOLDER/b_atf \
  -v /home/db/git/scripts/build_sdl.sh:/usr/bin/build_sdl.sh \
  -v /home/db/git/scripts/build_atf.sh:/usr/bin/build_atf.sh \
  ubuntu_18.04:latest "$@"

  # -v $HOST_WORK_FOLDER:$CONTAINER_WORK_FOLDER \
  # -v $HOST_SRC_FOLDER/sdl_core:$CONTAINER_WORK_FOLDER/sdl_core \
  # -v ~/workspace/0/3rd_party:$CONTAINER_WORK_FOLDER/3rd_party \
  # -v $REPORT_FOLDER/WS_$1:$CONTAINER_WORK_FOLDER/TestingReports \
  # -v $HOST_SRC_FOLDER/sdl_atf_test_scripts:$CONTAINER_WORK_FOLDER/sdl_atf_test_scripts \
