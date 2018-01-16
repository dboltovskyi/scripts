#!/usr/bin/env bash

NUM_OF_THREADS=1

# Set environment variables
export THIRD_PARTY_INSTALL_PREFIX=$HOME/3rd_party
export THIRD_PARTY_INSTALL_PREFIX_ARCH=$THIRD_PARTY_INSTALL_PREFIX
export LD_LIBRARY_PATH=$THIRD_PARTY_INSTALL_PREFIX/lib:.
export QMAKE=/opt/qt53/bin/qmake

log() {
  echo "["$(date +"%Y-%m-%d %H:%M:%S,%3N")"]" "$1$2$3"
}

# Handle 3rd party libs
if [ $SDL_3RD_PARTY_LIBS = "PREINSTALLED" ]; then
  cp -r /lib/3rd_party $HOME/
  NUM_OF_THREADS=$NUM_OF_THREADS_MAX
fi

# Build SDL
log "*** Building SDL ***"
log "SDL Repository: "$SDL_REPO
log "SDL Branch: "$SDL_BRANCH
log "SDL Policy: "$SDL_POLICY
cd $HOME
git clone -b $SDL_BRANCH $SDL_REPO
mkdir b
cd b
cmake ../sdl_core -DUSE_DISTCC=OFF -DUSE_CCACHE=OFF -DEXTENDED_POLICY=$SDL_POLICY -DBUILD_TESTS=$SDL_TESTS
make install -j$NUM_OF_THREADS
cp CMakeCache.txt ./bin/
rm -rf src
cd $HOME

# Build ATF
log "*** Building ATF ***"
log "ATF Repository: "$ATF_REPO
log "ATF Branch: "$ATF_BRANCH
cd $HOME
git clone -b $ATF_BRANCH $ATF_REPO
cd sdl_atf
git submodule init
git submodule update
make
log "Set path to SDL interfaces in ATF Config"
sed -i 's,config.pathToSDLInterfaces = "",config.pathToSDLInterfaces = "'"$HOME"'\/sdl_core\/src\/components\/interfaces",' modules/config.lua
log "Downloading runner"
wget -nv https://raw.githubusercontent.com/dboltovskyi/scripts/master/run.sh
chmod +x run.sh
cd $HOME

# Clone test scripts
log "*** Clonning Test Scripts ***"
log "Scripts Repository: "$SCRIPTS_REPO
log "Scripts Branch: "$SCRIPTS_BRANCH
cd $HOME
git clone -b $SCRIPTS_BRANCH $SCRIPTS_REPO
cd $HOME

# Create links between test scripts and ATF
log "*** Creating links between test scripts and ATF ***"
cd $HOME/sdl_atf
ln -s ../sdl_atf_test_scripts/files
ln -s ../sdl_atf_test_scripts/user_modules
ln -s ../sdl_atf_test_scripts/test_scripts
ln -s ../sdl_atf_test_scripts/test_sets
cd $HOME

log "*** Running test scripts ***"
cd $HOME/sdl_atf
./run.sh $HOME/b/bin $TARGET
