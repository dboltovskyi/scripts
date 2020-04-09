#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback

USER_ID=${LOCAL_USER_ID:-9001}

useradd -s /bin/bash -u $USER_ID -o -c "" -M developer
echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

chown developer /home/developer
chgrp developer /home/developer

export HOME=/home/developer
export THIRD_PARTY_INSTALL_PREFIX=$HOME/sdl/b/3rd_party
export THIRD_PARTY_INSTALL_PREFIX_ARCH=$THIRD_PARTY_INSTALL_PREFIX

echo "export LD_LIBRARY_PATH=$THIRD_PARTY_INSTALL_PREFIX/lib:." >> $HOME/.zshrc

# share ZSH command history between host and container
# mkdir -p /home/developer/.history
# echo "export HISTFILE=~/.history/.zsh_history" >> $HOME/.zshrc

# echo "Starting with UID : $USER_ID"
sudo -E -u developer "$@"
