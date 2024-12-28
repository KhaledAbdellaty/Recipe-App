# Recipe Sharing Flutter App

## Introduction
Welcome to the **Recipe Sharing App**! This project enables users to create, view, and interact with recipes, incorporating features like authentication, recipe feed, and interactive elements such as likes and comments.

## Features
- **User Authentication:** Login, logout, and sign-up functionality.
- **Recipe Feed:** Browse recipes with images, likes, and comments.
- **Recipe Creation:** Add recipes with title, categories,ingredients, instructions, and an  image.
- **Star Rating Widget:** Rate recipes and see average ratings.
- **Push Notifications:** Receive updates for interactions like comments or likes.

## Prerequisites

### Required Tools
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.3.4 or later)
- Android Studio or Visual Studio Code
- A Firebase project for backend services
- Git installed on your system

### Dependencies
Ensure you have the following dependencies in your `pubspec.yaml` file:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cached_network_image: null
  cloud_firestore: null
  cupertino_icons: ^1.0.6
  dartz: ^0.10.1
  equatable: ^2.0.7
  firebase_auth: null
  firebase_core: null
  firebase_messaging: null
  firebase_storage: null
  flutter_bloc: ^8.1.6
  flutter_rating_bar: ^4.0.1
  get_it: ^8.0.3
  http: ^1.2.2
  image_picker: null
  like_button: ^2.0.5
  shared_preferences: null
  uuid: ^4.5.1

dev_dependencies:
  flutter_lints: ^3.0.0
  flutter_test:
    sdk: flutter
```
---

## Setup Instructions

### Step 1: Clone the Repository
```bash
git clone https://github.com/KhaledAbdellaty/Recipe-App.git
cd recipe_app
```

### Step 2: Configure Firebase
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project and add your app (iOS & Android).
3. Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files.
4. Place them in the following directories:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Enable **Firebase Authentication**, **Firestore**, and **Cloud Storage**.

### Step 3: Install DependenciesNot
Run the following command to fetch all dependencies:
```bash
flutter pub get
```

### Step 4: Run the Application
To launch the app on a connected device or emulator:
```bash
flutter run
```

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author
Developed by Khaled Abdellaty
