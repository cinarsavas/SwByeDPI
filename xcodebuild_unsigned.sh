#!/bin/bash

XCODEPROJ_FILENAME="SwByeDPI.xcodeproj"
DESTINATION_TYPE="generic/platform=iOS"

# Build ByeDPIBg scheme (proxy with bg support)

XCODEPROJ_SCHEME="ByeDPIBg"

xcodebuild -project "$XCODEPROJ_FILENAME" \
    -scheme "$XCODEPROJ_SCHEME" \
    -destination "$DESTINATION_TYPE" \
    -configuration Release \
    -skipPackagePluginValidation \
    -skipMacroValidation \
    -archivePath "packages/$XCODEPROJ_SCHEME.xcarchive" \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    PROVISIONING_PROFILE="" \
    CODE_SIGN_ENTITLEMENTS="" \
    GCC_WARN_INHIBIT_ALL_WARNINGS=YES
    
if [ $? -ne 0 ]; then
    exit 1
fi
    
# Create IPA from ByeDPIBg build
    
mkdir -p packages/Payload
cp -r "packages/$XCODEPROJ_SCHEME.xcarchive/Products/Applications/ByeDPI.app" packages/Payload
(cd packages && zip -r "$XCODEPROJ_SCHEME"-unsigned.ipa Payload/)
rm -rf packages/Payload
rm -rf "packages/$XCODEPROJ_SCHEME.xcarchive"

# Build ByeByeDPI scheme (VPN client)

XCODEPROJ_SCHEME="ByeByeDPI"

xcodebuild -project "$XCODEPROJ_FILENAME" \
    -scheme "$XCODEPROJ_SCHEME" \
    -destination "$DESTINATION_TYPE" \
    -configuration Release \
    -skipPackagePluginValidation \
    -skipMacroValidation \
    -archivePath "packages/$XCODEPROJ_SCHEME.xcarchive" \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    PROVISIONING_PROFILE="" \
    CODE_SIGN_ENTITLEMENTS="" \
    GCC_WARN_INHIBIT_ALL_WARNINGS=YES
    
if [ $? -ne 0 ]; then
    exit 1
fi
    
# Apply NE entitlements
    
EXAMPLE_APP_SOURCES_DIR="Example/Sources"
ENTITLEMENT_PATH="$EXAMPLE_APP_SOURCES_DIR/ByeByeDPI/ByeByeDPI.entitlements"
BIN_PATH="packages/$XCODEPROJ_SCHEME.xcarchive/Products/Applications/$XCODEPROJ_SCHEME.app/$XCODEPROJ_SCHEME"

ldid -S"$ENTITLEMENT_PATH" "$BIN_PATH"

ENTITLEMENT_PATH="$EXAMPLE_APP_SOURCES_DIR/ByeByeDPITun/ByeByeDPITun.entitlements"
BIN_PATH="packages/$XCODEPROJ_SCHEME.xcarchive/Products/Applications/$XCODEPROJ_SCHEME.app/PlugIns/ByeByeDPITun.appex/ByeByeDPITun"

ldid -S"$ENTITLEMENT_PATH" "$BIN_PATH"

# Create IPA from ByeByeDPI build

mkdir -p packages/Payload
cp -r "packages/$XCODEPROJ_SCHEME.xcarchive/Products/Applications/$XCODEPROJ_SCHEME.app" packages/Payload
(cd packages && zip -r "$XCODEPROJ_SCHEME"-unsigned.ipa Payload/)
rm -rf packages/Payload
rm -rf "packages/$XCODEPROJ_SCHEME.xcarchive"
