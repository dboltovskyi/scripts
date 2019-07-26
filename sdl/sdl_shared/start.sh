#!/bin/bash

FLD=$(pwd)
SDL_BIN=$HOME/sdl/build/bin
SDL_PROCESS_NAME=smartDeviceLinkCore

trap ctrl_c INT

await() {
  local PID=$1
  local TIMEOUT=$2
  local TIME_LEFT=0
  while true
  do
    if ! ps -p $PID > /dev/null; then
      return 0
    fi
    if [ $TIME_LEFT -lt $TIMEOUT ]; then
      let TIME_LEFT=TIME_LEFT+1
      sleep 1
    else
      echo "Timeout ($TIMEOUT sec) expired. Force killing: ${PID} ..."
      kill -s SIGKILL ${PID}
      sleep 0.5
      return 0
    fi
  done
}

kill_sdl() {
  local PIDS=$(ps -ao user:20,pid,command | grep -e "^$(whoami).*$SDL_PROCESS_NAME" | grep -v grep | awk '{print $2}')
  for PID in $PIDS
  do
    echo "Killing: "$PID
    kill -s SIGTERM $PID
    await $PID 5
    log "Done"
  done
}

ctrl_c() {
  echo "Stopping SDL"
  kill_sdl
  exit 1
}

if [ -d $SDL_BIN ]; then
  echo "Removing SDL working files"
  cd $SDL_BIN
  rm -rf $SDL_BIN/storage $SDL_BIN/app_info.dat $SDL_BIN/*.log
  echo "Starting SDL"
  ./smartDeviceLinkCore
  cd $FLD
else
  echo "SDL binaries was not found in "$SDL_BIN
fi
