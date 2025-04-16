# Unit Tests

This folder contains the unit tests for the application, following the same Clean Architecture structure as the main project.

## 📁 Test Structure

### 🎯 Domain Tests
- `domain/entities/` - Tests for domain entities
- `domain/repositories/` - Tests for repository contracts
- `domain/usecases/` - Tests for use cases

### 📊 Data Tests
- `data/datasources/` - Tests for data sources
- `data/models/` - Tests for data models
- `data/repositories/` - Tests for repository implementations

### 📱 Presentation Tests
- `presentation/bloc/` - Tests for BLoCs
- `presentation/pages/` - Tests for pages
- `presentation/widgets/` - Tests for widgets

### 🛠️ Infrastructure Tests
- `infrastructure/error/` - Tests for error handling
- `infrastructure/network/` - Tests for network configuration
- `infrastructure/usecases/` - Tests for base use cases

## 📝 Naming Conventions

- Test files must end with `_test.dart`
- Test file names must correspond to the files they are testing
- Example: `user_repository_test.dart` for testing `user_repository.dart`

## 🧪 Running Tests

To run all tests:
```bash
flutter test
```

To run specific tests:
```bash
flutter test test/domain/entities/user_test.dart
``` 