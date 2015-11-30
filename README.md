# iOS Build Script
script to build iOS app

Easy to build, package and upload your app.

## How to Use

Copy archiveExample.sh, change config, rename.

### Build Configs

```
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
# you can change BUILD_PATH to your own path for testing script
#BUILD_DIR="archives/MyApp20151029010836"

# if you want update cocoapods
UPDATE_POD=false
```

After you have finished your config, just using `buildPackage` to build binary.

### Package IPA

```
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
```

After you have finished your config, just using `packageApp` to build binary.

Get final out put path using `FILEPATH1=$BUILD_PATH/$TARGET_IPA_NAME.ipa`.

You can change package config and package app many times with different developer sign and provision profile.

### Upload to pgyer.com

Call `uploadPgyer` to upload app to pgyer.com like this:

```
uploadPgyer $FILEPATH1 "password" "_api_key" "uKey">$LOG_PATH/$APP_NAME.upload.log
```

- `password` is password using to download your app at Pgyer.com
- `_api_key` is api key that provided by Pgyer.com
- `uKey` is uKey that provided by Pgyer.com

### Logs and DSYMs

You can find logs in `$LOG_PATH`, DYSM files in `$DSYM_PATH`.

Have fun.

## Todo:

- Support uploading to fir.im
