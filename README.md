# Smart Home Controller

## Description
This Flutter project provides a user interface to control various Arduino Uno devices via Bluetooth. It supports controlling LEDs, servo motors, and reading sensor data. Additionally, the app features facial recognition for user authentication, allowing users to create accounts and log in using their facial data.

## Installation and Usage
1. Ensure you have Flutter installed on your system.
2. Clone this repository to your local machine.
3. Open the project in your preferred IDE.
4. Run the command `flutter run` in the terminal to compile and run the application on your device.

## Technologies Used
- **Dart**: Programming language used to develop the application logic.
- **Flutter**: Framework used to build the user interface and manage the application logic.
- **Flutter Bluetooth Serial**: Package for Bluetooth connectivity.
- **Firebase ML Kit**: Used for implementing face recognition and authentication.
- **Permission Handler**: Package for managing permissions.
- **Shared Preferences**: Package for local storage of connected device data.
- **Camera**: Flutter package used for camera functionalities.
- **Path Provider**: Package used to handle file storage and retrieval.
- **Facial Recognition**: Technology for secure user authentication (details of implementation are in authentication_service.dart).

## File Structure
- `main.dart`: Main file containing the entry point of the application.
- `auth_screen.dart`: Screen handling the authentication logic and user interface.
- `camera_screen.dart`: Screen for capturing the user's face using the device's camera.
- `Models`: Directory containing the models that the aplication needs.
- `services`: Directory containing the services for face recognition and data handling.
- `Widgets`: Directory containing the widgets  for face recognition and data handling.
- `Connections`: Directory containing the implement of the Bluetooth connection logic.

## Help
If you need help with Flutter development, here are some useful commands and resources:

### Common Flutter Commands
- **Run the app**: `flutter run`
- **Build the app**: `flutter build <platform>`
- **Analyze the code**: `flutter analyze`
- **Run tests**: `flutter test`
- **Clean the project**: `flutter clean`

### Useful Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter GitHub Repository](https://github.com/flutter/flutter)
- [Dart Packages](https://pub.dev/)
- [Firebase ML Kit Documentation](https://firebase.google.com/docs/ml-kit)

## Additional Resources
If you have problems, here are some resources to help you get started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Deployment
You can deploy this application on any device that supports Flutter. Simply compile the project and load it onto your device.

## Inspiration and Design
This project draws inspiration from various sources; however, I do not claim ownership of the design elements used. This project is purely for interactive purposes.

## Development
This project was developed by `©ChrisAlegria`. All rights reserved. Unauthorized reproduction or distribution of this project, or any portion of it, is prohibited.
