# tokko_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Run on iOS Simulator (Short Guide)

1) Prerequisites
- Install Xcode from the App Store
- Install CocoaPods: `sudo gem install cocoapods`
- Ensure Flutter is set up: `flutter doctor`

2) Start a Simulator
- Open Simulator: `open -a Simulator`
- Or boot a specific device: `xcrun simctl boot "iPhone 15"`

3) Run the app
- From project root:
  - `flutter pub get`
  - `flutter run -d ios`
- List devices: `flutter devices`
- Target a device: `flutter run -d "iPhone 15"`

4) Open iOS module in Xcode (optional)
- `open ios/Runner.xcworkspace`
- Press Run (Play) to build on the selected simulator

Troubleshooting
- If build fails on first run: `flutter clean` then `cd ios && pod install && cd ..`
- If CocoaPods repo issues: `cd ios && pod repo update && pod install && cd ..`
- If Xcode CLI tools not set: `sudo xcode-select --switch /Applications/Xcode.app`
