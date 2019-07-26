#!/bin/bash

export HOME=/home/developer

USER_ID=${LOCAL_USER_ID:-9001}
SDL=$HOME/sdl
HMI=$HOME/sdl/sdl_hmi

echo "Configuring and starting web server"
sed 's|\/var\/www\/html|'"$HMI"'|' -i /etc/lighttpd/lighttpd.conf
/etc/init.d/lighttpd start

echo "Adding 'developer' user"
useradd -s /bin/bash -u $USER_ID -o -c "" -M developer
echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown developer $HOME
chgrp developer $HOME
chown developer $HOME/.zshrc
chgrp developer $HOME/.zshrc

echo "Running init script"
sudo -E -u developer $SDL/init.sh

echo "Executing command under 'developer' user: $@"
sudo -E -u developer "$@"
