#!/bin/sh
set -e
xctool -project iMerPhotos.xcodeproj -scheme iMerPhotos -sdk iphonesimulator build test
#

#xctool -workspace workspace.xcworkspace -scheme LikeApp build test
#MyWorkspace MyScheme
