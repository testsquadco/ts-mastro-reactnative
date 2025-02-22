#!/bin/bash

set -e

echo "🏗️ Building applications for testing..."

# Create directories if they don't exist
mkdir -p apps/apk
mkdir -p apps/ipa

# Build Android APK
echo "📱 Building Android APK..."
cd ../android
./gradlew clean assembleRelease
cp app/build/outputs/apk/release/app-release.apk ../maestro-testing/apps/apk/

# Build iOS IPA
echo "🍎 Building iOS IPA..."
cd ../ios
xcodebuild clean
xcodebuild -workspace MyApp.xcworkspace \
           -scheme MyApp \
           -configuration Release \
           -sdk iphoneos \
           -archivePath MyApp.xcarchive \
           archive
xcodebuild -exportArchive \
           -archivePath MyApp.xcarchive \
           -exportOptionsPlist exportOptions.plist \
           -exportPath ../maestro-testing/apps/ipa/

echo "✅ Build completed successfully!" 