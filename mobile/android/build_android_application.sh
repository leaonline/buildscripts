#!/usr/bin/env bash

METEOR_PROJECT_PATH=$(pwd)/simple-todos # /home/runner/work/buildscripts/buildscripts
ANDROID_HOME= /home/runner/android-sdk
cd $ANDROID_HOME
sdkmanager "build-tools;27.0.0"
cd simple-todos || exit
SERVER="${APPLICATION_NAME}.meteor.com"
APPLICATION_NAME="$(basename "$METEOR_PROJECT_PATH")_Android_Application"

#cd "${METEOR_PROJECT_PATH}"/.. || exit # go back to root so android project will create on root and not in script folder



if [ -d "${APPLICATION_NAME}" ]; then  # check if apk build already exists, if not continue. 
				     # If android build already exists remove it, otherwise it will throw errors. 
  sudo rm -rf "${APPLICATION_NAME}" 

fi


export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools
echo $PATH


meteor add-platform android
meteor build "${APPLICATION_NAME}" --server="${SERVER}"



