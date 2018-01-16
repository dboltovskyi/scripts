#!/usr/bin/env bash

# Script that allows to run multiple .lua scripts at once
# Usage: run.sh <path_to_sdl_bin> <path_to_scripts>
# Instead of <path_to_scripts> <path_to_test_set> or <path_to_folder> can be used

SDL_FOLDER=$1
ATF_FOLDER=.
RUN_TARGET=$2
CONFIG=$3
PLAY_SOUND=/usr/share/sounds/freedesktop/stereo/complete.oga
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FOLDER="TestingReportsArch"
REPORT="Report.txt"
REPORT_CONSOLE="Console.txt"
LINE="====================================================================================================="

REPORT_FOLDER=${ATF_FOLDER}/${REPORT_FOLDER}/${TIMESTAMP}

log() {
  echo "${1}${2}${3}"
}

logf() {
  echo "${1}${2}${3}" | tee -a ${REPORT_FOLDER}/${REPORT}
}

backup() {
  log "Back-up SDL files"
  cp -n ${SDL_FOLDER}/sdl_preloaded_pt.json ${SDL_FOLDER}/_sdl_preloaded_pt.json
  cp -n ${SDL_FOLDER}/smartDeviceLink.ini ${SDL_FOLDER}/_smartDeviceLink.ini
  cp -n ${SDL_FOLDER}/hmi_capabilities.json ${SDL_FOLDER}/_hmi_capabilities.json
  cp -n ${SDL_FOLDER}/log4cxx.properties ${SDL_FOLDER}/_log4cxx.properties
}

restore() {
  log "Restoring SDL files from back-up"
  cp -f ${SDL_FOLDER}/_sdl_preloaded_pt.json ${SDL_FOLDER}/sdl_preloaded_pt.json
  cp -f ${SDL_FOLDER}/_smartDeviceLink.ini ${SDL_FOLDER}/smartDeviceLink.ini
  cp -f ${SDL_FOLDER}/_hmi_capabilities.json ${SDL_FOLDER}/hmi_capabilities.json
  cp -f ${SDL_FOLDER}/_log4cxx.properties ${SDL_FOLDER}/log4cxx.properties
}

clean_backup() {
  log "Cleaning up back-up SDL files"
  rm -f ${SDL_FOLDER}/_sdl_preloaded_pt.json
  rm -f ${SDL_FOLDER}/_smartDeviceLink.ini
  rm -f ${SDL_FOLDER}/_hmi_capabilities.json
  rm -f ${SDL_FOLDER}/_log4cxx.properties
}

kill_sdl() {
  sleep 0.2
  PID="$(ps -ef | grep -e "^$(whoami).*smartDeviceLinkCore" | grep -v grep | awk '{print $2}')"
  if [ -n "$PID" ]; then
    log "SDL is running, PID: $PID"
    log "Killing SDL"
    kill -9 $PID
  fi
  sleep 0.2
}

create_log_folder() {
  mkdir -p ${REPORT_FOLDER}
}

create_log_folder_for_script() {
  mkdir ${REPORT_FOLDER}/Script_"${ID_SFX}"
}

copy_logs() {
  cp `find ${ATF_FOLDER}/TestingReports/ -name "*.*"` ${REPORT_FOLDER}/Script_"${ID_SFX}"/
  cp ${ATF_FOLDER}/ErrorLog.txt ${REPORT_FOLDER}/Script_"${ID_SFX}"/
}

clean() {
  log "Cleaning up ATF folder"
  rm -f ${ATF_FOLDER}/ErrorLog.txt
  rm -f ${ATF_FOLDER}/sdl.pid
  rm -f ${ATF_FOLDER}/mobile*.out
  rm -f -r ${ATF_FOLDER}/TestingReports
  log "Cleaning up SDL folder"
  rm -f ${SDL_FOLDER}/*.log
  rm -f ${SDL_FOLDER}/app_info.dat
  rm -f ${SDL_FOLDER}/policy.sqlite
  rm -f -r ${SDL_FOLDER}/storage
  rm -f -r ${SDL_FOLDER}/ivsu_cache
  rm -f -r ${SDL_FOLDER}/../sdl_bin_bk
}

run() {
  log ${LINE}

  ID=$((ID+1))
  ID_SFX=$(printf "%0${#NUM_OF_SCRIPTS}d" $ID)

  log "Processing script: " ${ID}"("${NUM_OF_SCRIPTS}")"

  kill_sdl

  clean

  restore

  create_log_folder_for_script

  ./start.sh $SCRIPT --sdl-core=${SDL_FOLDER} \
    | tee >(sed -u "s/\x1b[^m]*m//g" > ${REPORT_FOLDER}/Script_"${ID_SFX}"/${REPORT_CONSOLE})

  RESULT_CODE=${PIPESTATUS[0]}
  RESULT="NOT_DEFINED"

  case "${RESULT_CODE}" in
    0)
      RESULT="PASSED"
      LIST_PASSED[ID]=$ID_SFX:$SCRIPT
    ;;
    1)
      RESULT="ABORTED"
      LIST_ABORTED[ID]=$ID_SFX:$SCRIPT
    ;;
    2)
      RESULT="FAILED"
      LIST_FAILED[ID]=$ID_SFX:$SCRIPT
    ;;
    4)
      RESULT="SKIPPED"
      LIST_SKIPPED[ID]=$ID_SFX:$SCRIPT
    ;;
  esac

  log "SCRIPT STATUS: " ${RESULT}

  kill_sdl

  copy_logs
}

process() {
  create_log_folder

  ID=0
  EXT=${RUN_TARGET: -3}
  if [ $EXT = "txt" ]; then
    NUM_OF_SCRIPTS=$(cat $RUN_TARGET | egrep -v -c '^;')
    while read -r line
    do
      if [ ${line:0:1} = ";" ]; then
        continue
      fi
      SCRIPT=$(echo $line | awk '{print $1}')
      run
    done < "$RUN_TARGET"
  elif [ $EXT = "lua" ]; then
    NUM_OF_SCRIPTS=1
    SCRIPT=$RUN_TARGET
    run
  else
    NUM_OF_SCRIPTS=$(find $RUN_TARGET -iname "[0-9]*.lua" | wc -l)
    for line in $(find $RUN_TARGET -iname "[0-9]*.lua" | sort)
    do
      SCRIPT=$line
      run
    done
  fi
}

status() {
  logf "TOTAL: " $ID
  logf "PASSED: " ${#LIST_PASSED[@]}
  logf "ABORTED: " ${#LIST_ABORTED[@]}
  for i in ${LIST_ABORTED[@]}
  do
    logf $i
  done
  logf "FAILED: " ${#LIST_FAILED[@]}
  for i in ${LIST_FAILED[@]}
  do
    logf $i
  done
  logf "SKIPPED: " ${#LIST_SKIPPED[@]}
  for i in ${LIST_SKIPPED[@]}
  do
    logf $i
  done
}

play_finish_sound() {
  if [ -f $PLAY_SOUND ] && [ -f "/usr/bin/paplay" ]; then
    paplay $PLAY_SOUND
  fi
}

log ${LINE}

backup

process

log ${LINE}

restore

clean_backup

log ${LINE}

status

log ${LINE}

play_finish_sound
