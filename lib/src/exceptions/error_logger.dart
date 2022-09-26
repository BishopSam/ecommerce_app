import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * can be replaced with any crash reporting tool
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception){
     // * can be replaced with any crash reporting tool
    debugPrint('$exception');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
