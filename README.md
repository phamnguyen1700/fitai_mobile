# FitAI Mobile

Flutter ứng dụng fitness AI - ứng dụng theo dõi sức khỏe và tập luyện thông minh.

## Cấu trúc dự án

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── config/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   ├── app_constants.dart
│   │   └── app_router.dart
│   │
│   ├── network/
│   │   ├── api_service.dart
│   │   ├── dio_client.dart
│   │   └── app_exception.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   └── extensions.dart
│   │
│   ├── status/                     # 🆕 Các màn hình & widget toàn cục
│   │   ├── error_screen.dart       # Hiển thị khi lỗi hệ thống
│   │   ├── empty_screen.dart       # Hiển thị khi không có dữ liệu
│   │   └── loading_screen.dart     # Hiển thị khi đang xử lý API
│   │
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_appbar.dart
│       ├── app_loader.dart
│       └── app_error_widget.dart   # Widget nhỏ hiển thị lỗi trong từng màn hình
│
├── features/
│   ├── welcome/
│   │   └── presentation/
│   │       ├── viewmodels/welcome_notifier.dart
│   │       └── views/welcome_screen.dart
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository.dart
│   │   ├── domain/
│   │   │   └── usecases/login_usecase.dart
│   │   └── presentation/
│   │       ├── viewmodels/auth_notifier.dart
│   │       └── views/login_screen.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── viewmodels/home_notifier.dart
│   │       └── views/home_screen.dart
│   │
│   ├── exercise/
│   │   └── presentation/
│   │       ├── viewmodels/exercise_notifier.dart
│   │       └── views/exercise_screen.dart
│   │
│   ├── meal/
│   │   └── presentation/
│   │       ├── viewmodels/meal_notifier.dart
│   │       └── views/meal_screen.dart
│   │
│   ├── progress/
│   │   └── presentation/
│   │       ├── viewmodels/progress_notifier.dart
│   │       └── views/progress_screen.dart
│   │
│   └── profile/
│       └── presentation/
│           ├── viewmodels/profile_notifier.dart
│           └── views/profile_screen.dart
│
└── shared/
    └── navigation/
        ├── bottom_nav_bar.dart
        ├── navigation_provider.dart
        └── app_scaffold.dart         # 🆕 Scaffold tổng cho layout toàn app
```

## Mô tả các thư mục

### Core
- **config/**: Cấu hình ứng dụng (màu sắc, theme, constants, router)
- **network/**: Xử lý API và network calls
- **utils/**: Các utility functions và extensions
- **status/**: Các màn hình trạng thái toàn cục (loading, error, empty)
- **widgets/**: Các widget tái sử dụng

### Features
Mỗi feature được tổ chức theo Clean Architecture:
- **welcome/**: Màn hình chào mừng
- **auth/**: Xác thực người dùng (đăng nhập, đăng ký)
- **home/**: Màn hình chính
- **exercise/**: Quản lý bài tập
- **meal/**: Quản lý bữa ăn
- **progress/**: Theo dõi tiến độ
- **profile/**: Thông tin cá nhân

### Shared
- **navigation/**: Các component điều hướng chung cho toàn app

## Công nghệ sử dụng

### Core Technologies
- **Flutter**: Framework phát triển ứng dụng di động (Flutter 3.10+)
- **Material Design 3**: UI/UX design system mới nhất của Google
- **Clean Architecture**: Kiến trúc code sạch và có thể bảo trì

### State Management & Navigation
- **Riverpod**: Quản lý state hiện đại với code generation
- **go_router**: Navigation routing mạnh mẽ và type-safe

### Network & Data
- **Dio**: HTTP client với interceptors, timeout, error handling
- **JSON Serialization**: Tự động parse JSON từ API
- **flutter_secure_storage**: Lưu trữ dữ liệu nhạy cảm an toàn

## Cài đặt Dependencies

### 1. Core Packages
```bash
# State Management
flutter pub add flutter_riverpod
flutter pub add riverpod_annotation
flutter pub add riverpod_generator --dev

# Navigation
flutter pub add go_router

# Network & Storage
flutter pub add dio
flutter pub add pretty_dio_logger
flutter pub add flutter_secure_storage

# JSON Serialization
flutter pub add json_annotation
flutter pub add json_serializable --dev
flutter pub add build_runner --dev
```

### 2. Material Design 3
Material 3 đã được tích hợp sẵn trong Flutter 3.10+, chỉ cần bật trong `ThemeData`:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
)
```

### 3. Phiên bản tương thích (Flutter 3.10+)

| Package | Version | Mô tả |
|---------|---------|-------|
| `flutter_riverpod` | ^2.4.0 | State management chính |
| `riverpod_annotation` | ^2.3.0 | Code generation cho Riverpod |
| `riverpod_generator` | ^2.3.0 | Generator cho Riverpod |
| `go_router` | ^12.0.0 | Navigation routing |
| `dio` | ^5.4.0 | HTTP client |
| `pretty_dio_logger` | ^1.3.1 | Logging cho Dio |
| `flutter_secure_storage` | ^9.0.0 | Secure storage |
| `json_annotation` | ^4.8.0 | JSON serialization |
| `json_serializable` | ^6.7.0 | JSON generator |
| `build_runner` | ^2.4.0 | Code generation runner |

## Cấu hình Project

### 1. pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  
  # Navigation
  go_router: ^12.0.0
  
  # Network & Storage
  dio: ^5.4.0
  pretty_dio_logger: ^1.3.1
  flutter_secure_storage: ^9.0.0
  
  # JSON
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  riverpod_generator: ^2.3.0
  json_serializable: ^6.7.0
  build_runner: ^2.4.0
```

### 2. Chạy Code Generation
```bash
# Sau khi thêm dependencies
flutter pub get

# Generate code cho Riverpod và JSON
flutter packages pub run build_runner build
```

## Kiến trúc và Best Practices

### 1. Material Design 3
- Sử dụng `ColorScheme.fromSeed()` cho dynamic theming
- Tách theme thành `app_theme.dart` và `app_colors.dart`
- Hỗ trợ Dark/Light mode tự động

### 2. Riverpod Architecture
- Sử dụng `@riverpod` annotation cho code generation
- Tách biệt Provider, Notifier, và Repository
- Type-safe state management

### 3. Clean Architecture
- **Presentation**: UI và State Management (Riverpod)
- **Domain**: Business Logic và Use Cases
- **Data**: Repository, Models, và API calls

### 4. Error Handling
- Global error handling với Dio interceptors
- Custom exception classes
- User-friendly error messages

### 5. Security
- Secure storage cho tokens và sensitive data
- API key management
- Input validation và sanitization