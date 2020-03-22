#!/usr/bin/env bash

cd ..

METEOR_PROJECT_PATH=$(pwd)
SERVER="${APPLICATION_NAME}.meteor.com"
ANDROID_HOME=/usr/lib/android-sdk
APPLICATION_NAME="$(basename "$METEOR_PROJECT_PATH")_Android_Application"

cd ${METEOR_PROJECT_PATH}

ANDROID_PLATFORM=${METEOR_PROJECT_PATH}/.meteor/local/cordova-build/platforms/android

if [ ! -d $ANDROID_PLATFORM ]; then
	meteor add-platform android
fi

sudo apt-get update 
sudo apt-get upgrade
yes | sudo apt-get install openjdk-8-jre
yes | sudo apt-get install openjdk-8-jdk
sudo apt update
yes | sudo apt install android-sdk
yes | sudo apt-get install unzip
cd ~
if [ ! -d $ANDROID_HOME/tools/bin ]; then
wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
unzip tools_r25.2.3-linux.zip
rm tools_r25.2.3-linux.zip

sudo rm -rf $ANDROID_HOME/tools

sudo mv tools $ANDROID_HOME/tools
fi

export ANDROID_HOME=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export ANDROID_ROOT=${ANDROID_HOME}

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export JRE_HOME
export PATH


sudo update-alternatives --config java <<< '2'
sudo update-alternatives --config javac <<< '2'

if [ ! -f $ANDROID_HOME/licenses/android-sdk-license ]; then

sudo chown $USER:$USER $ANDROID_HOME -R
yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.2"

fi


cd ${METEOR_PROJECT_PATH}

if [ -d ${APPLICATION_NAME} ]; then
sudo rm -rf ${APPLICATION_NAME}
fi

meteor build ${APPLICATION_NAME} --server=${SERVER}


