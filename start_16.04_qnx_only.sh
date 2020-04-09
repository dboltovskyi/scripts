#!/usr/bin/env bash

vmplayer ~/vmimages/qnx700.x86_64_$1/x86_64/QNX_SDP.vmx &

sleep 6

QNX_IP_MASK="172.16.141.13"

ssh qnxuser@$QNX_IP_MASK$1 "sh -c '. /etc/profile; ./RemoteTestingAdapterServer > /dev/null 2>&1 &'"

