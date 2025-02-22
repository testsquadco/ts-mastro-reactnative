# Maestro Testing Framework for React Native

A comprehensive end-to-end testing framework for React Native applications using Maestro. This framework supports both iOS and Android platforms with features like parallel test execution, automatic screenshot capture on failures, and detailed test reporting.

## Features

- 🌍 **Cross-Platform Testing**: Run tests on both iOS and Android
- ⚡ **Parallel Test Execution**: Run tests concurrently for faster feedback
- 📸 **Automatic Screenshots**: Capture screenshots on test failures
- 🔄 **Multiple Environments**: Support for qa, staging, and production environments
- 📊 **Detailed Reporting**: Integration with Allure for comprehensive test reports
- 🔄 **CI/CD Ready**: Configured for GitHub Actions

## Prerequisites

- Node.js 16+
- React Native CLI
- Maestro CLI
- Allure Command Line Tool
- iOS Setup (for iOS testing):
  - Xcode 14+
  - iOS Simulator
- Android Setup (for Android testing):
  - Android Studio
  - Android SDK
  - Android Emulator

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-repo/maestro-testing.git
```

2. Run the setup script:

```bash
./scripts/setup-environment.sh
```

This will:
- Install required dependencies
- Set up Maestro CLI
- Install Allure reporting tool
- Create necessary directories

## Project Structure

```
maestro-testing/
├── apps/                  # Built application binaries
│   ├── apk/              # Android APKs
│   └── ipa/              # iOS IPAs
├── config/               # Environment configurations
│   ├── qa.env
│   ├── staging.env
│   └── prod.env
├── scripts/              # Automation scripts
├── tests/                # Test files
│   ├── common/          # Shared test utilities
│   ├── login/           # Login-related tests
│   └── signup/          # Signup-related tests
└── screenshots/         # Failure screenshots
```

## Writing Tests

1. Create a new YAML file in the appropriate feature folder under `tests/`
2. Use testID attributes for element selection
3. Follow this template:

```yaml
appId: ${APP_ID}
env:
  CUSTOM_VAR: "value"

---
- launchApp
- assertVisible: "Welcome"
- tapOn:
    id: "button-id"
```

## Running Tests

### Build Apps
```bash
./scripts/build-apps.sh
```

### Run Tests Sequentially
```bash
./scripts/run-tests.sh [environment] [platform]
```
Example:
```bash
./scripts/run-tests.sh qa android
```

### Run Tests in Parallel
```bash
node scripts/parallel-runner.js [environment] [platform] [threads]
```
Example:
```bash
node scripts/parallel-runner.js qa android 4
```

## Test Reports

1. Tests automatically generate Allure reports
2. View the report:
```bash
allure serve allure-results
```
or
```bash
allure generate allure-results -o allure-report --clean
allure open allure-report
```

## Environment Configuration

1. Copy the example environment file:
```bash
cp config/qa.env.example config/qa.env
```

2. Update the variables in the env file:
```bash
export TEST_EMAIL="qa.user@testsquad.com"
export TEST_PASSWORD="qaPassword123"
export BASE_URL="https://api-qa.testsquad.com"
```

## CI/CD Integration

The framework includes GitHub Actions workflows for automated testing:
- Triggered on pull requests and pushes to main
- Runs tests in parallel
- Generates and uploads test reports
- Captures and stores failure screenshots

## Debugging

### Screenshots
- Failed test screenshots are stored in `screenshots/failures/`
- Named with pattern: `timestamp_testname_step.png`

### Logs
- Test execution logs are available in Allure reports
- Real-time logs during test execution
- Detailed error messages with stack traces

## Best Practices

1. **Test IDs**
   - Use meaningful testID attributes
   - Follow naming convention: `screen-element-type`
   ```jsx
   <Button testID="login-submit-button" />
   ```

2. **Test Organization**
   - Group related tests in feature folders
   - Use common utilities for shared functionality
   - Keep tests focused and independent

3. **Environment Variables**
   - Don't commit sensitive data
   - Use environment-specific configurations
   - Document required variables

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT

## Support

For support, please open an issue in the GitHub repository.

