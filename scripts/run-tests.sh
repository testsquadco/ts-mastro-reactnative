#!/bin/bash

set -e

ENVIRONMENT=$1
PLATFORM=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$PLATFORM" ]; then
    echo "Usage: ./run-tests.sh [environment] [platform]"
    echo "Example: ./run-tests.sh qa android"
    exit 1
fi

# Load environment variables
source ./config/${ENVIRONMENT}.env

# Set platform-specific app ID
if [ "$PLATFORM" == "android" ]; then
    export APP_ID="com.testsquad.myapp"
else
    export APP_ID="com.testsquad.myapp.ios"
fi

# Create directories
mkdir -p screenshots/failures
mkdir -p allure-results

# Clean previous results
rm -rf allure-results/*

echo "🚀 Running tests for ${ENVIRONMENT} on ${PLATFORM}..."

# Run Maestro tests
for test in tests/**/*.yaml; do
    TEST_NAME=$(basename "$test" .yaml)
    echo "Running test: ${TEST_NAME}"
    
    maestro test --env APP_ID=$APP_ID \
                 --env BASE_URL=$BASE_URL \
                 --env TEST_EMAIL=$TEST_EMAIL \
                 --env TEST_PASSWORD=$TEST_PASSWORD \
                 --env TEST_NAME=$TEST_NAME \
                 --format allure \
                 "$test" || {
        echo "❌ Test failed: ${TEST_NAME}"
        maestro test tests/common/screenshots.yaml \
            --env APP_ID=$APP_ID \
            --env TEST_NAME=$TEST_NAME \
            --env STEP_NAME="failure"
    }
done

echo "📊 Generating Allure report..."
allure generate allure-results -o allure-report --clean

echo "✅ Testing completed!" 