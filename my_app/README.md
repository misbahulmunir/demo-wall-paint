# AR Wall Paint App

A Flutter application that allows you to paint virtual objects in augmented reality.

## Prerequisites

- Flutter SDK (latest version)
- Android Studio / Xcode
- A physical device that supports AR:
  - Android: Device must support ARCore
  - iOS: iPhone 6s or newer

## Setup

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd my_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

## Running the App

### Android
1. Connect an ARCore-supported Android device
2. Enable Developer Options and USB Debugging
3. Run the app:
   ```bash
   flutter run
   ```

### iOS
1. Connect an ARKit-supported iPhone (6s or newer)
2. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
3. Select your device and run the app

## Features

- Paint virtual objects in AR space
- Change colors using the color picker
- Clear all painted objects
- Tap to place objects in the AR environment

## Troubleshooting

If you see the error "MirrorManager: this model don't Support":
- Make sure you're using a device that supports ARCore (Android) or ARKit (iOS)
- Check that you have granted camera permissions
- Ensure you're running the app on a physical device (AR is not supported on emulators)

## Dependencies

- arkit_plugin: ^1.1.2
- flutter_colorpicker: ^1.0.3
- permission_handler: ^11.1.0
- vector_math: ^2.1.4

## License

This project is licensed under the MIT License.
