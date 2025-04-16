# Flutter App - Flutter Clean Architecture

This project follows Clean Architecture and SOLID principles, implementing a clear and maintainable structure.

## 🚀 Project Setup Guide

This is a Flutter app skeleton that requires several configurations before running. Follow these steps to set up your project:

### 🔥 Firebase Configuration
1. Create a new Firebase project
2. Add your platforms (Android/iOS) to the Firebase project
3. Download and place the configuration files:
   - Android: Place `google-services.json` in `android/app/`
   - iOS: Place `GoogleService-Info.plist` in `ios/Runner/`
4. Generate your own `firebase_options.dart` file using FlutterFire CLI:
   ```bash
   flutterfire configure
   ```
5. Replace the existing `firebase_options.dart` in `lib/data/` with your generated file

### 📦 Package Name Configuration
1. Change the package name using the change_app_package_name tool:
   ```bash
   flutter pub run change_app_package_name:main com.your.package.name
   ```

### 📱 App Name Configuration
1. Android: Update `android/app/src/main/AndroidManifest.xml`
   ```xml
   <application
       android:label="Your App Name"
       ...
   ```
2. iOS: Update `ios/Runner/Info.plist`
   ```xml
   <key>CFBundleName</key>
   <string>Your App Name</string>
   ```

### 📊 Azbox.io Configuration
1. Create an account at [azbox.io](https://azbox.io)
2. Create a new project
3. Update the following values in `lib/infrastructure/constants/constants.dart`:
   ```dart
   static const String kAzboxApiKey = 'YOUR_AZBOX_API_KEY';
   static const String kAzboxProjectId = 'YOUR_AZBOX_PROJECT_ID';
   ```

### 🔗 Privacy Policy and Terms of Service
Update the URLs in `lib/infrastructure/constants/constants.dart`:
```dart
static const String privacyPolicyUrl = 'YOUR_PRIVACY_POLICY_URL';
static const String termsOfServiceUrl = 'YOUR_TERMS_OF_SERVICE_URL';
```

### 📈 Analytics Configuration (Optional)
If you want to use analytics services, update the following in `lib/infrastructure/constants/constants.dart`:

#### PostHog
```dart
static const String posthogApiKey = 'YOUR_POSTHOG_API_KEY';
static const String posthogHost = 'YOUR_POSTHOG_HOST'; // 'https://eu.i.posthog.com' or 'https://us.i.posthog.com'
```

#### Heap
```dart
static const String heapEnvId = 'YOUR_HEAP_ENVIRONMENT_ID';
```

### 🔔 Push Notifications (Optional)
To enable push notifications using OneSignal, update in `lib/infrastructure/constants/constants.dart`:
```dart
static const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
```

### 🏃‍♂️ Running the Project
After completing all configurations:
```bash
flutter pub get
flutter run
```


## 🏗️ Project Architecture

The application is divided into the following layers:

### 💉 Dependency Injection
Manages application dependency injection.

```
di/
└── di.dart       # Dependency injection configuration
```

- **di.dart**: Central dependency configuration
  - Registers services and dependencies
  - Configures the injection container (GetIt)
  - Initializes dependencies in the correct order

### 📱 Presentation
Contains everything related to UI and state management.

```
presentation/
├── bloc/         # State managers using BLoC pattern
├── pages/        # Complete application screens
└── widgets/      # Reusable components
```

- **bloc/**: Implements the BLoC (Business Logic Component) pattern
  - Handles presentation logic
  - Manages UI states
  - Communicates UI with use cases

### 🎯 Domain
Contains business logic and application rules.

```
domain/
├── entities/     # Pure business objects
├── repositories/ # Repository contracts
└── usecases/    # Application use cases
```

- **entities/**: Defines business objects
  - No external dependencies
  - Represent core business concepts
  - No implementation logic

- **repositories/**: Define contracts (interfaces)
  - Specify how data should be accessed
  - No implementation, only definitions

- **usecases/**: Contain business logic
  - Each use case represents a specific action
  - Implements business rules
  - Orchestrates data flow between repositories

### 📊 Data
Implements data access and manipulation.

```
data/
├── datasources/  # Data sources (API, local DB, etc.)
├── models/       # Entity implementations
└── repositories/ # Repository implementations
```

- **datasources/**: Manages data sources
  - Implements API communication
  - Handles local storage
  - Manages Firebase or other services

- **models/**: Implements domain entities
  - Extends entities with specific functionality
  - Includes serialization/deserialization
  - Maps data between data and domain layers

- **repositories/**: Implements domain contracts
  - Coordinates multiple data sources
  - Implements cache logic
  - Handles errors and exceptions

### 🛠️ Infrastructure
Contains cross-cutting configurations and utilities.

```
infrastructure/
├── error/       # Error handling
├── network/     # Network configuration
└── usecases/    # Base use cases
```

- **error/**: Centralized error management
  - Defines common error types
  - Implements failure handling

- **network/**: Network utilities
  - Interceptors
  - Connectivity handling
  - Timeout configuration

## 🔄 Data Flow

1. UI triggers events through BLoC
2. BLoC communicates with use cases
3. Use cases use repositories
4. Repositories coordinate data sources
5. Data flows back following the same path

## 📦 SOLID Principles

- **S**: Single Responsibility Principle
  - Each class has a single responsibility

- **O**: Open/Closed Principle
  - Entities are open for extension, closed for modification

- **L**: Liskov Substitution Principle
  - Derived types must be substitutable for their base types

- **I**: Interface Segregation Principle
  - Contracts are divided into smaller interfaces

- **D**: Dependency Inversion Principle
  - Dependencies flow toward abstractions