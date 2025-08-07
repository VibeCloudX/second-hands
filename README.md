# myapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI/CD Setup

This project uses GitHub Actions for continuous integration and deployment:

### Workflows

1. **CI Workflow** (ci.yml)
   - Triggered on push to main/develop branches and PRs
   - Runs tests, linting, and code analysis
   - Uploads test coverage to Codecov

2. **Build Workflows** (build.yml, build_ios.yml)
   - Builds Android APK, iOS app, and Web release versions
   - Triggered on push to main branch and PRs
   - Artifacts are uploaded for review

3. **Deploy Workflow** (deploy.yml)
   - Triggered when a new tag is pushed (format: v*)
   - Creates a GitHub Release
   - Builds and attaches APK and IPA to the release
   - Uploads iOS build to TestFlight
   - Deploys web version to Firebase Hosting

4. **Flutter Version Management** (flutter_version.yml)
   - Validates Flutter version and dependencies
   - Triggered when pubspec files change

### Deployment

To create a new release:
1. Update the version in `pubspec.yaml`
2. Create and push a new tag: `git tag v1.0.0 && git push --tags`
3. The deploy workflow will automatically build and publish the release

### Required Secrets

For deployment to work properly, add these secrets to your GitHub repository:

**Firebase (Web Deployment):**
- `FIREBASE_SERVICE_ACCOUNT`: Firebase service account credentials
- `FIREBASE_PROJECT_ID`: Your Firebase project ID

**iOS Deployment:**
- `APPLE_CERTIFICATE_BASE64`: Base64-encoded Apple distribution certificate (.p12)
- `APPLE_CERTIFICATE_PASSWORD`: Password for the certificate
- `APPLE_PROVISIONING_PROFILE_BASE64`: Base64-encoded provisioning profile
- `KEYCHAIN_PASSWORD`: Password for the temporary keychain
- `APPLE_TEAM_ID`: Your Apple Developer Team ID
- `APPLE_ID`: Your Apple ID email
- `BUNDLE_IDENTIFIER`: Your app's bundle identifier
- `PROVISIONING_PROFILE_NAME`: Name of the provisioning profile
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API Key Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API Key content
