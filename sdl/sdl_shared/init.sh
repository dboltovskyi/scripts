#!/usr/bin/env bash

echo "USER:" $(id -un)
echo "PWD:" $(pwd)
echo "HOME:" $HOME

SDL=$HOME/sdl
SDL_BIN=$SDL/build/bin
HMI_BIN=$SDL/sdl_hmi
THIRD_PARTY=$SDL/build/3rd_party

echo "export THIRD_PARTY_INSTALL_PREFIX="$THIRD_PARTY >> $HOME/.zshrc
echo "export THIRD_PARTY_INSTALL_PREFIX_ARCH="$THIRD_PARTY >> $HOME/.zshrc
echo "export LD_LIBRARY_PATH="$THIRD_PARTY"/lib:." >> $HOME/.zshrc
echo "export PATH=$PATH:$HOME/sdl" >> $HOME/.zshrc

if [ ! -d $HMI_BIN$SDL_BIN ]; then
  echo "Creating symlink for App Storage folder"
  mkdir -p $HMI_BIN$SDL/build
  ln -s ../../../../../build/bin $HMI_BIN$SDL_BIN
fi
