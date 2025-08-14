import 'package:logger/logger.dart';

class LoggerUtil {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static bool _isInitialized = false;

  static void init() {
      _isInitialized = true;
  }

  static void debug(String message) {
    if (_isInitialized) {
      logger.d(message);
    }
  }

  static void error(String message, [dynamic error]) {
    if (_isInitialized) {
      logger.e(message, error: error, stackTrace: StackTrace.current);
    }
  }

  static void warning(String message) {
    if (_isInitialized) {
      logger.w(message);
    }
  }

  static void info(String message) {
    if (_isInitialized) {
      logger.i(message);
    }
  }

  static void verbose(String message) {
    if (_isInitialized) {
      logger.v(message);
    }
  }

}