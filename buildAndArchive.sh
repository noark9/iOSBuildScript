#!bin/sh

# build and acrhive shell script

declare -i ret

function buildPackage()
{
    target_name="$APP_NAME"
    target_path="$TARGET_PATH"
    mkdir -p $target_path

    # update pod
    if $UPDATE_POD; then
        echo "\033[33mInfo: Updating Pods\033[0m"
        cd $PROJECT_PATH
        pod install --verbose>$LOG_PATH/$APP_NAME.pod.log
        ret=$?
        cd -
        if [ $ret -ne 0 ]; then
            return $ret
        fi
    fi

    echo "\033[33mInfo: Change Provisioning to Automatic\033[0m"
    xcproj -p $PROJECT_FILE_PATH -t $TARGET_NAME write-build-setting "PROVISIONING_PROFILE" ""
    ret=$?
    if [ $ret -ne 0 ]; then
        return $ret
    fi

    # build app
    echo "\033[33mInfo: Building App\033[0m"
    xcrun xcodebuild -workspace $PROJECT_WORKSPACE_PATH -scheme $SCHEME_NAME -configuration $CONFIGURATION_NAME -sdk iphoneos SYMROOT=$target_path/build>$LOG_PATH/$target_name.build.log
    ret=$?
    if [ $ret -ne 0 ]; then
        return $ret
    fi

    mv $target_path/build/Release-iphoneos/$APP_NAME.app.dSYM $DSYM_PATH/$target_name.app.dSYM

    echo "\033[33mInfo: App have been packaged successed\033[0m"
    echo
    return 0
}

function packageApp()
{
    echo "\033[33mInfo: Packaging $TARGET_IPA_NAME\033[0m"
    xcrun -sdk iphoneos PackageApplication -v "$TARGET_PATH/build/Release-iphoneos/$APP_NAME.app" -o "$BUILD_PATH/$TARGET_IPA_NAME.ipa" --sign "$DEVELOPER_NAME" --embed "$PROFILE_PATH">"$LOG_PATH/$TARGET_IPA_NAME.package.log"

    if [ $? -eq 0 ]; then
        echo "\033[032mPackage path: $BUILD_PATH/$TARGET_IPA_NAME.ipa\033[0m"
    else
        return $?
    fi

    return 0
}

function uploadPgyer()
{
    curl -F"file=@$1" -F"password=$2" -F"_api_key=$3" -F"uKey=$4" http://www.pgyer.com/apiv1/app/upload
}
