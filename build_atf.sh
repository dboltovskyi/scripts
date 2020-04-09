#!/bin/bash

ATF_SRC_DIR=../sdl_atf
ATF_TS_SRC_DIR=../sdl_atf_test_scripts
SDL_SRC_DIR=../sdl_core
BUILD_DIR=bin

if [ $(ls -a | grep .git | wc -l) != "0" ]; then
  echo "Current folder contains git sources"
  exit 0
fi

rm -rf *

cmake $ATF_SRC_DIR \
    -DCMAKE_INSTALL_PREFIX=./$BUILD_DIR \
    -DBUILD_WITH_CLIENT_LOGGING=OFF \
    -DBUILD_WITH_SERVER_LOGGING=OFF \
  && make install

if [ ! -d $BUILD_DIR ]; then
  echo "ATF binaries was not found"
  exit 1
fi

find . -maxdepth 1 ! -name $BUILD_DIR ! -name '.' -exec rm -rf {} +
mv ./$BUILD_DIR/* .
rm -rf $BUILD_DIR

ln -s $ATF_TS_SRC_DIR/files
ln -s $ATF_TS_SRC_DIR/test_scripts
ln -s $ATF_TS_SRC_DIR/test_sets
ln -s $ATF_TS_SRC_DIR/user_modules

# rm -rf modules
# ln -s ../sdl_atf/modules
# ln -s ../sdl_atf/tools

ln -s $ATF_SRC_DIR/run.sh
# rm start.sh
# ln -s $ATF_SRC_DIR/start.sh

cp $SDL_SRC_DIR/src/components/interfaces/HMI_API.xml ./data/
cp $SDL_SRC_DIR/src/components/interfaces/MOBILE_API.xml ./data/
