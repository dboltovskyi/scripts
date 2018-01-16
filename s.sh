#!/usr/bin/env bash

log() {
  echo "["$(date +"%Y-%m-%d %H:%M:%S,%3N")"]" "$1$2$3"
}

log "*** Downloading processing script ***"
export HOME=/home
cd $HOME
wget https://raw.githubusercontent.com/dboltovskyi/scripts/master/process.sh
chmod +x process.sh
./process.sh

log "*** Copying report to the host ***"
USER_ID=${LOCAL_USER_ID:-9001}
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
exec /usr/local/bin/gosu user cp -r $HOME/sdl_atf/TestingReportsArch/* /home/reports/
