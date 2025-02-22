#!/bin/bash

echo "🔧 Setting up test environment..."

# Install dependencies
npm install

# Install Maestro CLI if not installed
if ! command -v maestro &> /dev/null; then
    echo "Installing Maestro CLI..."
    curl -Ls "https://get.maestro.mobile.dev" | bash
fi

# Install Allure if not installed
if ! command -v allure &> /dev/null; then
    echo "Installing Allure..."
    npm install -g allure-commandline
fi

# Create necessary directories
mkdir -p apps/apk
mkdir -p apps/ipa
mkdir -p screenshots/failures
mkdir -p allure-results

echo "✅ Environment setup completed!" 