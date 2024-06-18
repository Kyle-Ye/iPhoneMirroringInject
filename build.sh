#!/bin/zsh

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

PROJECT_ROOT="$(dirname $(filepath $0))"

cd $PROJECT_ROOT

rm -rf output
xcodebuild -scheme iPhoneMirroringInject -configuration Release -derivedDataPath output
export IMINJECT_PATH=./output/Build/Products/Release/libiPhoneMirroringInject.dylib

rm -rf  ./iPhone\ Mirroring.app
cp -R /System/Applications/iPhone\ Mirroring.app ./

rm -rf IM.entitlements
codesign --display --xml --entitlements IM.entitlements ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring
plutil -insert "com\.apple\.security\.cs\.allow-dyld-environment-variables" -bool YES IM.entitlements
codesign -s - --deep --force --options=runtime --entitlements IM.entitlements ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring

DYLD_INSERT_LIBRARIES=$IMINJECT_PATH ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring