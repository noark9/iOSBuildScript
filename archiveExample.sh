#!/bin/sh

# use current path for build
SCRIPT_BASE=`pwd`

# path where locate your project
PROJECT_PATH="/Users/apple/Documents/projectpath"

# workspace name
PROJECT_WORKSPACE="MyProject.xcworkspace"

# where to find your workspace
PROJECT_WORKSPACE_PATH="$PROJECT_PATH/$PROJECT_WORKSPACE"

# project file name
PROJECT_FILE_NAME="MyProject.xcodeproj"

# project file path
PROJECT_FILE_PATH="$PROJECT_PATH/$PROJECT_FILE_NAME"

# target to build
TARGET_NAME="TargetNameInXcode"

# scheme name to build
SCHEME_NAME="SchemeNameInXcode"

# out put app name also prefix for log files
APP_NAME="IPA file name"

# configuration name Release or Debug
CONFIGURATION_NAME="Release"

# tool for modify plist file
PB="/usr/libexec/PlistBuddy"

# time stamp for current build
TIMESTEMP=`date +%Y%m%d%H%M%S`

# use timestamp for build path you can change later
BUILD_DIR="archives/$APP_NAME$TIMESTEMP"
# you can change BUILD_PATH to your own path
#BUILD_DIR="archives/MyApp20151029010836"

cd ..
if [ ! -d $BUILD_DIR ]; then
  mkdir -p $BUILD_DIR
fi
cd $BUILD_DIR
BUILD_PATH=`pwd`
LOG_PATH=$BUILD_PATH/log
if [ ! -d $LOG_PATH ]; then
    mkdir -p $LOG_PATH
fi
DSYM_PATH=$BUILD_PATH/dsyms
if [ ! -d $DSYM_PATH ]; then
    mkdir -p $DSYM_PATH
fi

# build target path
TARGET_PATH=$BUILD_PATH/$TARGET_NAME

# if you want update cocoapods
UPDATE_POD=false

# import build script
. $SCRIPT_BASE/buildAndArchive.sh

echo "\033[33mInfo: Start $APP_NAME Build\033[0m"
declare -i ret
ret=0
# build package
buildPackage
ret=$?

# package with same output you can call packageApp many times

# package first package
# profile file name
PROFILE_NAME="profilename.mobileprovision"

# profile path
PROFILE_PATH=$SCRIPT_BASE/$PROFILE_NAME

# developer name use user id eg.
# DEVELOPER_NAME="CCF342CZ34"
DEVELOPER_NAME=""

# ipa name
TARGET_IPA_NAME=$APP_NAME

# package app
if [ $ret -eq 0 ]; then
    packageApp
    ret=$?
fi

FILEPATH1=$BUILD_PATH/$TARGET_IPA_NAME.ipa

# package second package you can change provisioning profile and sign user
# profile file name
PROFILE_NAME="profilename.mobileprovision"

# profile path
PROFILE_PATH=$SCRIPT_BASE/$PROFILE_NAME

# developer name use user id eg.
# DEVELOPER_NAME="CCF342CZ34"
DEVELOPER_NAME=""

# ipa name
TARGET_IPA_NAME=$APP_NAME.copy

# package app
if [ $ret -eq 0 ]; then
    packageApp
    ret=$?
fi

FILEPATH2=$BUILD_PATH/$TARGET_IPA_NAME.ipa

open $BUILD_PATH

echo
echo "\033[32mBuild script path: $SCRIPT_BASE\033[0m"
echo "\033[32mLogging path: $LOG_PATH\033[0m"
echo "\033[32mDSYM file path: $DSYM_PATH\033[0m"
echo

if [ $ret -eq 0 ]; then
    echo "All has been done!!! Have fun!!!🍻 "
else
    echo "\033[91m😱 😱 😱 Build Failed!!!!!!\033[0m"
fi
echo

# upload every package to pyger.com for Ad-hoc user install
echo "\033[33mInfo: Uploading $FILEPATH1\033[0m"
uploadPgyer $FILEPATH1 "password" "_api_key" "uKey">$LOG_PATH/$APP_NAME.upload.log
if [[ $? -ne 0 ]]; then
    echo "\033[91mUpload $FILEPATH1 failed try it later"
fi
echo "\033[33mInfo: Uploading $FILEPATH2\033[0m"
uploadPgyer $FILEPATH2 "password" "_api_key" "uKey">$LOG_PATH/$APP_NAME.copy.upload.log
if [[ $? -ne 0 ]]; then
    echo "\033[91mUpload $FILEPATH2 failed try it later"
fi

echo "\033[33mInfo: Upload finished!\033[0m"
