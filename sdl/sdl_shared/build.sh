#!/bin/bash

FLOW=$1
THREADS=3

FLD=$(pwd)

WD=$HOME/sdl/build

find $WD -maxdepth 1 ! -path $WD ! -name '3rd_party' | xargs rm -rf

cd $WD

cmake ../sdl_core \
    -DUSE_DISTCC=OFF \
    -DUSE_CCACHE=OFF \
    -DBUILD_BT_SUPPORT=OFF \
    $FLOW \
  && make install-3rd_party_logger \
  && make install -j$THREADS

rm -rf ./src

cd $FLD
