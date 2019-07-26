#!/usr/bin/env bash

SDL=$HOME/sdl
SDL_BIN=$SDL/build/bin
HMI_BIN=$SDL/sdl_hmi

if [ -d $SDL_BIN ]; then
  echo "Copying certificates"
  cp -f $SDL/crt/* $SDL_BIN/
fi

if [ -d $SDL_BIN ]; then
  echo "Removing SDL working files"
  rm -rf $SDL_BIN/storage $SDL_BIN/app_info.dat $SDL_BIN/*.log
fi

function set_param() {
  local file_name=$1
  local param_name=$2
  local param_value=$3
  sed 's|^\('"$param_name"'[ ]*=\).*|\1'"$param_value"'|g' -i "$file_name"
}

if [ -d $SDL_BIN ]; then
  echo "Updating SDL config files"
  set_param "$SDL_BIN/smartDeviceLink.ini" "ServerAddress" "0.0.0.0"
  set_param "$SDL_BIN/smartDeviceLink.ini" "StartStreamRetry" "3, 3000"
  # set_param "$SDL_BIN/log4cxx.properties" "log4j.rootLogger" "ALL, SmartDeviceLinkCoreLogFile, Console"
  # set_param "$SDL_BIN/start.sh" "LD_LIBRARY_PATH" "/home/developer/sdl/3rd_party/lib:. ./smartDeviceLinkCore"
fi

function update_preloaded() {
  local file_name=$SDL_BIN/sdl_preloaded_pt.json
  local cmd=$1
  jq $cmd $file_name | sponge $file_name
}

if [ -d $SDL_BIN ]; then
  IS_APP_DEFINED=$(jq '.policy_table.app_policies | has("584421907")' $SDL_BIN/sdl_preloaded_pt.json)
  if [ "$IS_APP_DEFINED" == "false" ]; then
    echo "Updating SDL preloaded file"
    update_preloaded '.policy_table.app_policies["584421907"]=.policy_table.app_policies.default'
    update_preloaded '.policy_table.app_policies["584421907"].groups=["Location-1","Base-4"]'
    # update_preloaded '.policy_table.app_policies["584421907"].encryption_required=true'
    # update_preloaded '.policy_table.functional_groupings["Location-1"].encryption_required=true'
    # update_preloaded 'del(.policy_table.functional_groupings["Location-1"].rpcs["GetVehicleData"].parameters)'
    # update_preloaded 'del(.policy_table.functional_groupings["Location-1"].rpcs["OnVehicleData"].parameters)'
    # update_preloaded 'del(.policy_table.functional_groupings["Location-1"].rpcs["SubscribeVehicleData"].parameters)'
    # update_preloaded 'del(.policy_table.functional_groupings["Location-1"].rpcs["UnsubscribeVehicleData"].parameters)'
  fi
fi
