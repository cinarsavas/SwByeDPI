#!/bin/bash

xcodebuild -project SwByeDPI.xcodeproj \
    -scheme ByeByeDPI \
    -destination 'generic/platform=iOS' \
    -configuration Release \
    -archivePath packages/ByeByeDPI.xcarchive \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    GCC_WARN_INHIBIT_ALL_WARNINGS=YES
    
ldid -SExample/Sources/ByeByeDPI/ByeByeDPI.entitlements packages/ByeByeDPI.xcarchive/Products/Applications/ByeByeDPI.app/ByeByeDPI
ldid -SExample/Sources/ByeByeDPITun/ByeByeDPITun.entitlements packages/ByeByeDPI.xcarchive/Products/Applications/ByeByeDPI.app/PlugIns/ByeByeDPITun.appex/ByeByeDPITun

mkdir -p packages/Payload
cp -r packages/ByeByeDPI.xcarchive/Products/Applications/ByeByeDPI.app packages/Payload
cd packages && zip -r ByeByeDPI.ipa Payload/
rm -rf Payload
