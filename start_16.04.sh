#!/usr/bin/env bash

docker run \
	-it \
	--cap-add NET_ADMIN \
	-e THIRD_PARTY_INSTALL_PREFIX=/home/3rd_party \
	-e THIRD_PARTY_INSTALL_PREFIX_ARCH=/home/3rd_party \
	-e LD_LIBRARY_PATH=/home/3rd_party/lib:. \
	ubuntu_16.04:01
