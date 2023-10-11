// main.dart
import 'dart:developer' as developer;

// Blue text
void logInfo(Object? object) {
  String msg = "$object";
  developer.log('\x1B[34m$msg\x1B[0m');
}

// Green text
void logSuccess(Object? object) {
  String msg = "$object";
  developer.log('\x1B[32m$msg\x1B[0m');
}

// Yellow text
void logWarning(Object? object) {
  String msg = "$object";
  developer.log('\x1B[33m$msg\x1B[0m');
}

// Red text
void logError(Object? object) {
  String msg = "$object";
  developer.log('\x1B[31m$msg\x1B[0m');
}
