#!/usr/bin/env bash
HOST_SRC_FOLDER=~/ramdrv
HOST_WORK_FOLDER=~/workspace/$1
CONTAINER_WORK_FOLDER=/home/developer/sdl
REPORT_FOLDER=~/ramdrv/TestingReports

if [ ! -d $REPORT_FOLDER/WS_$1 ] ; then
  mkdir $REPORT_FOLDER/WS_$1
fi

vmplayer ~/vmimages/qnx700.x86_64_$1/x86_64/QNX_SDP.vmx &

sleep 6

QNX_IP_MASK="172.16.141.13"

ssh qnxuser@$QNX_IP_MASK$1 "sh -c '. /etc/profile; ./RemoteTestingAdapterServer > /dev/null 2>&1 &'"

docker run \
  -it \
  --rm \
  --cap-add NET_ADMIN \
  -e LOCAL_USER_ID=$(id -u) \
  -v $HOST_WORK_FOLDER:$CONTAINER_WORK_FOLDER \
  -v $HOST_SRC_FOLDER/sdl_atf_test_scripts:$CONTAINER_WORK_FOLDER/sdl_atf_test_scripts \
  -v $REPORT_FOLDER/WS_$1:$CONTAINER_WORK_FOLDER/TestingReports \
  ubuntu_16.04:01
