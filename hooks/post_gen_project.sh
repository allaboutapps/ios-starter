#! /bin/bash

echo "Fetching strings"
./buildStrings

echo "Create xcode project file now? : y/n "

read XCODE_GEN

if [ "$XCODE_GEN" == "y" ];then
  xcodegen
fi

echo "Perform carthage update now? : y/n "

read RUN_CARTHAGE 

if [ "$RUN_CARTHAGE" == "y" ];then
  carthage update --platform ios --cache-builds
fi

pwd

if [ "$XCODE_GEN" == "y" ];then
  xed .
fi

printf 'all done - enjoy \xf0\x9f\x9a\x80\n'
