#!/bin/bash

THREADS=4

function build() {
  local FLOW=$1

  case $FLOW in
    PROPRIETARY)
      WD="p"
      ;;
    EXTERNAL_PROPRIETARY)
      WD="e"
      ;;
    HTTP)
      WD="h"
      ;;
  esac

  echo FLOW: $FLOW
  echo THREADS: $THREADS

  if [ ! -z $FLOW ]; then
    FLOW="-DEXTENDED_POLICY=$FLOW"
  fi

  rm -rf $WD
  mkdir $WD
  cd $WD

  cmake ../../../sdl_core \
      -DUSE_DISTCC=OFF \
      -DUSE_CCACHE=OFF \
      -DBUILD_BT_SUPPORT=OFF \
      -DBUILD_TESTS=OFF \
      -DBUILD_WEBSOCKET_SERVER_SUPPORT=ON \
      -DENABLE_IAP2EMULATION=ON \
      $FLOW \
    && make install-3rd_party_logger \
    && make install -j$THREADS

  rm -rf src

  cd ..
}

if [ ! -z $1 ]; then
  build $1 $2 $3 $4
else
  build "PROPRIETARY" $2 $3 $4
  build "EXTERNAL_PROPRIETARY" $2 $3 $4
  build "HTTP" $2 $3 $4
fi

# -DENABLE_SECURITY=OFF \
# -DBUILD_TESTS=ON
# -DENABLE_LOG=OFF
