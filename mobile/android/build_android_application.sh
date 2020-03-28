#!/usr/bin/env bash

METEOR_PROJECT_PATH=$(pwd)
SERVER="${APPLICATION_NAME}.meteor.com"
APPLICATION_NAME="$(basename $METEOR_PROJECT_PATH)_Android_Application"

cd ${METEOR_PROJECT_PATH}/.. # go back to root so android project will create on root and not in 				     # script folder

if [ -d ${APPLICATION_NAME} ]; then  # check if apk build already exists, if not continue. 
				     # If android build already exists remove it, otherwise it will throw errors. 
  sudo rm -rf ${APPLICATION_NAME} 

fi

meteor build ${APPLICATION_NAME} --server=${SERVER}



