import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/presentation/sign_in/email_password_sign_in_state.dart';

class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final error = _findError(newValue);
    final errorLogger = container.read(errorLoggerProvider);
    if (error != null) {
      if (error.error is AppException) {
        // only prints the AppException data
       errorLogger.logAppException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is EmailPasswordSignInState && value.value is AsyncError) {
      return value.value as AsyncError;
    } else if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
