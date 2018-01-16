#!/usr/bin/env bash

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

cd $HOME
wget https://raw.githubusercontent.com/dboltovskyi/scripts/master/process.sh
chmod +x process.sh

exec /usr/local/bin/gosu user $HOME/process.sh
