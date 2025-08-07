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

2. **Build Workflow** (build.yml)
   - Builds Android APK and Web release versions
   - Triggered on push to main branch and PRs
   - Artifacts are uploaded for review

3. **Deploy Workflow** (deploy.yml)
   - Triggered when a new tag is pushed (format: v*)
   - Creates a GitHub Release
   - Builds and attaches APK to the release
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
- `FIREBASE_SERVICE_ACCOUNT`: Firebase service account credentials
- `FIREBASE_PROJECT_ID`: Your Firebase project ID
