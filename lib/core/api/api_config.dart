// ignore_for_file: constant_identifier_names

/// Environment configuration for API endpoints
class ApiConfig {
  // ===========================================
  // 1. Environment flags
  // ===========================================
  static const bool IS_PRODUCTION = false; // Set true when deploying production
  static const bool USE_MOCK_API = false; // For testing only

  // ===========================================
  // 2. Base URLs for each service
  // ===========================================

  /// 🚀 Production URLs
  static const String ACCOUNT_PROD_URL = 'https://api.fitai.com/account';
  static const String FITNESS_PROD_URL = 'https://api.fitai.com/fitness';

  /// 🧪 Development URLs
  static const String ACCOUNT_DEV_URL = 'http://54.179.34.55:8081';
  static const String FITNESS_DEV_URL = 'http://54.179.34.55:8082';

  /// 🖥 Local development (optional)
  static const String ACCOUNT_LOCAL_URL = 'http://localhost:8001';
  static const String FITNESS_LOCAL_URL = 'http://localhost:8002';

  /// Mock for testing
  static const String MOCK_URL = 'https://jsonplaceholder.typicode.com';

  // ===========================================
  // 3. Methods to select correct environment
  // ===========================================

  static String get accountBaseUrl {
    if (USE_MOCK_API) return MOCK_URL;
    if (IS_PRODUCTION) return ACCOUNT_PROD_URL;
    return ACCOUNT_DEV_URL;
  }

  static String get fitnessBaseUrl {
    if (USE_MOCK_API) return MOCK_URL;
    if (IS_PRODUCTION) return FITNESS_PROD_URL;
    return FITNESS_DEV_URL;
  }

  // API version
  static const String API_VERSION = '/api';

  // ===========================================
  // 4. Full URLs (base + API version)
  // ===========================================
  static String get accountFullBaseUrl => '$accountBaseUrl$API_VERSION';
  static String get fitnessFullBaseUrl => '$fitnessBaseUrl$API_VERSION';

  // ===========================================
  // 5. Extra configs
  // ===========================================
  static const bool ENABLE_LOGGING = true;
  static const bool ENABLE_ERROR_TRACKING = false;

  static const int CONNECT_TIMEOUT = 30;
  static const int RECEIVE_TIMEOUT = 30;
  static const int SEND_TIMEOUT = 30;

  static const String DEFAULT_DEVICE_NAME = 'FitAI Mobile App';

  // ===========================================
  // 6. Debug print
  // ===========================================
  static void printConfiguration() {
    print('=== API Configuration ===');
    print('Environment: ${IS_PRODUCTION ? 'PRODUCTION' : 'DEVELOPMENT'}');
    print('Using Mock: $USE_MOCK_API');
    print('Account Base URL: $accountFullBaseUrl');
    print('Fitness Base URL: $fitnessFullBaseUrl');
    print('Logging Enabled: $ENABLE_LOGGING');
    print('========================');
  }
}
